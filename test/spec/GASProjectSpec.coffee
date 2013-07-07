ScriptMangager = required['apiClass']

describe "GASProject", ()->
  apiKey = ScriptProperties.getProperty("apiKey")
  fileId = ScriptProperties.getProperty("fileId")
  scriptManager = ScriptManager.create(apiKey : apiKey)
  describe "#constructor",()->

    it "should set properties, fileId, filename, manager, origin", ()->
      project = scriptManager.getProject(fileId)
      expect(project).toBeDefined()
      expect(project.fileId).toBe(fileId)
      expect(project.filename).toBeDefined()
      expect(project.manager).toBe(scriptManager)
      expect(project.origin).toBeDefined()
      @

    it "should allow null args", ()->
      expect(()->new ScriptManager.GASProject).not.toThrow()
      @
    @

    describe "#getFiles", ()->

      project = scriptManager.getProject(fileId)

      it "should get files as a GASFile", ()->
        files = project.getFiles()
        expect(files).toEqual(jasmine.any(Array))

        for f in files
          expect(f).toEqual(jasmine.any(ScriptManager.GASFile))
        @

      it "should return empty array, if does not exists files", ()->
        files = new ScriptManager.GASProject().getFiles()
        expect(files).toEqual(jasmine.any(Array))
        expect(files.length).toBe(0)
        @
      @

    describe "#getFileByName", ()->
      project = scriptManager.getProject(fileId)
      it "should get a file by filename", ()->
        code = project.getFileByName("code")
        expect(code).toBeDefined()
        expect(code).toEqual(jasmine.any(ScriptManager.GASFile))
        @

      it "should return null, if not found", ()->
        code = project.getFileByName("")
        expect(code).toBeNull()
        @
      @

    describe "#addFile",()->
      project = scriptManager.getProject(fileId)
      it "should add file to own", ()->
        filename = new Date().toString()
        project.addFile(filename, "server_js", "//code")
        file = project.getFileByName(filename)
        expect(file).not.toBeNull()
        expect(file.name).toEqual(filename)
        expect(file.type).toEqual("server_js")
        expect(file.source).toEqual("//code")
        @
      it "should return own", ()->
        p = project.addFile("hoge", "html", "fuga")
        expect(p).toBe(project)
        @
      @
    describe "#renameFile", ()->
      project = null
      beforeEach ()->
        project = scriptManager.getProject(fileId)
        project.addFile("test-2" , "server_js", "test")
        @

      it "should rename child file", ()->
        filename = new Date().toString()
        project.renameFile("test-2", filename)
        file = project.getFileByName(filename)
        expect(file).not.toBeNull()
        expect(project.getFileByName("test-2")).toBeNull()
        @
      it "should return own", ()->
        p = project.renameFile("test", "fuga")
        expect(p).toBe(project)
        @
      @
    describe "#deleteFile", ()->
      project = null
      beforeEach ()->
        project = scriptManager.getProject(fileId)
        project.addFile("test" , "server_js", "test")
        @

      it "should delete a file by name", ()->
        project.deleteFile("test")
        expect(project.getFileByName("test")).toBeNull()
        @

      it "should not throw error if file is not found", ()->
        expect(()->project.deleteFile("hoge")).not.toThrow()
        @
      @
    describe "#deploy",()->

      it "should deploy project", ()->
        project = scriptManager.getProject(fileId)
        project.addFile("test" , "server_js", "test")
        newProject = project.deploy()
        reget = scriptManager.getProject(fileId)
        expect(reget.getFileByName("test")).not.toBeNull()
        expect(newProject.fileId).toBe(reget.fileId)
        project.deleteFile("test").deploy()
        @
      it "should create new project, if does not have fileId", ()->
        newProject = scriptManager.createProject("new project")
        .addFile("hoge", "server_js", "//test")
        .deploy()
        reget = scriptManager.getProject(newProject.fileId)
        expect(newProject.fileId).toBe(reget.fileId)
        expect(newProject.getFileByName("hoge")).not.toBeNull()
        expect(newProject.filename).toBe("new project")
        DriveApp.removeFile(DriveApp.getFileById(newProject.fileId))
        @
      @
    describe "#create",()->
      it "should create new project", ()->
        project = scriptManager.getProject(fileId)
        project.addFile("test" , "server_js", "test")
        newProject = project.create()
        expect(newProject.getFileByName("test")).not.toBeNull()
        expect(newProject.fileId).not.toBe(project.fileId)
        DriveApp.removeFile(DriveApp.getFileById(project.fileId))
        DriveApp.removeFile(DriveApp.getFileById(newProject.fileId))
        @
      @
    @
  @