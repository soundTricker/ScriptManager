class ScriptManager
    @DOWNLOAD_URL_BASE = "https://script.google.com/feeds/download/export?id=%s&format=json"
    @SCOPES = [
        "https://www.googleapis.com/auth/drive"
        "https://www.googleapis.com/auth/drive.file"
        "https://www.googleapis.com/auth/drive.scripts"
    ].join("+")

    constructor:(@options={})->
        @options.consumerKey = @options.consumerKey || 'anonymous'
        @options.consumerSecret = @options.consumerSecret || 'anonymous'
        @options.oauthName = @options.oauthName || 'ScriptManager'
        oauthConfig = UrlFetchApp.addOAuthService(@options.oauthName)
        oauthConfig.setConsumerKey(@options.consumerKey)
        oauthConfig.setConsumerSecret( @options.consumerSecret)
        oauthConfig.setRequestTokenUrl("https://www.google.com/accounts/OAuthGetRequestToken?scope=#{ScriptManager.SCOPES}")
        oauthConfig.setAuthorizationUrl('https://accounts.google.com/OAuthAuthorizeToken')
        oauthConfig.setAccessTokenUrl('https://www.google.com/accounts/OAuthGetAccessToken')
        
    getProject:(fileId)=>
        option = @generateFetchOption_('get')
        url = Utilities.formatString ScriptManager.DOWNLOAD_URL_BASE, fileId
        res = UrlFetchApp.fetch(url,option).getBlob()
        json = res.getDataAsString()
        name = res.getName()
        return new GASProject name, fileId,  @, JSON.parse(json)
        
        
    generateFetchOption_:(method)=>
        option = 
            method : method
            oAuthServiceName : @options.oauthName
            oAuthUseToken: "always"
            
        return option
    
    createProject:(projectName)->
        return new GASProject projectName , null, @ {files : []}
    
    createNewProject_:(filename, project)=>
        
        options = @generateFetchOption_('post')
        options.payload = JSON.stringify(project)
        options.contentType = 'application/vnd.google-apps.script+json'
        res = UrlFetchApp.fetch("https://www.googleapis.com/upload/drive/v2/files?convert=true#{if @options.apiKey then '&key=' + @options.apiKey else ''}",options)
        
        json = JSON.parse(res.getContentText())
        
        if filename
            options = @generateFetchOption_('put')
            options.payload = JSON.stringify(title : filename)
            options.contentType = 'application/json'
            res = UrlFetchApp.fetch("https://www.googleapis.com/drive/v2/files/#{json.id}#{if @options.apiKey then '?key=' + @options.apiKey else ''}",options)
            json = JSON.parse(res.getContentText())
        return new GASProject json.title , json.id,  @, project
        
    updateProject_:(fileId, project)=>
        options = @generateFetchOption_('put')
        options.payload = JSON.stringify(project)
        options.contentType = 'application/vnd.google-apps.script+json'
        res = UrlFetchApp.fetch("https://www.googleapis.com/upload/drive/v2/files/#{fileId}#{if @options.apiKey then '?key=' + @options.apiKey else ''}",options)
        json = JSON.parse(res.getContentText())
        return new GASProject json.title, fileId, @, project

class GASProject
    constructor:(@filename, @fileId, @manager, @origin)->
        
    getFiles:()->
        return (new GASFile(@manager, origin) for origin in @origin.files)
        
    getFileByName:(filename)=>
        filtered = @origin.files.filter((file)-> file.name == filename)
        if filtered.length == 1
            return new GASFile(@manager, filtered[0])
        else
            return null
    
    addFile:(name, type, source)=>
        @origin.files.push(
            name : name
            type : type
            source : source
        )
        return @
        
    renameFile:(from , to)=>
        file = @getFileByName(from)
        file? && file.name = to
        return @
        
    deleteFile:(filename)=>
        @origin.files = @origin.files.filter((file)-> file.name != filename)
        return @
    
    deploy:()=>
        if fileId
            @manager.updateProject_(@fileId, @origin)
        else
            @manager.createNewProject_(@filename, @origin)
        
    create:()=>
        @manager.createNewProject_(@filename, @origin)
        
class GASFile
    constructor:(@manager, @origin)->
        for k,v of @origin
            o = @origin
            get = do(key=k)-> ()-> o[key]
            set = do(key=k)-> (value)-> o[key] = value
        
            Object.defineProperty(@, k, 
                get : get
                set : set
            )
    