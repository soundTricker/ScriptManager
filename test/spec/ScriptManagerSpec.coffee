describe "ScriptManager", ()->
  apiKey = ScriptProperties.getProperty("apiKey")
  fileId = ScriptProperties.getProperty("fileId")

  it "should have create method",()->
    expect(ScriptManager.create).toBeDefined()
    expect(typeof ScriptManager.create).toBe('function')
    @

  it "should have getProject method, it's a code assitant method",()->
    expect(ScriptManager.getProject).toBeDefined()
    expect(typeof ScriptManager.getProject).toBe('function')
    expect(ScriptManager.getProject).toThrow('this is mock function, should not call directly. Please call "create" method before calling this')
    @

  it "should have createProject method, it's a code assitant method",()->
    expect(ScriptManager.createProject).toBeDefined()
    expect(typeof ScriptManager.createProject).toBe('function')
    expect(ScriptManager.getProject).toThrow('this is mock function, should not call directly. Please call "create" method before calling this')
    @

  describe '#create method', ()->

    it 'given api key', ()->
      expect(()-> ScriptManager.create()).toThrow("given apiKey")
      @

    it 'should create ScriptManager instance', ()->
      scriptManager = ScriptManager.create(apiKey : 'hoge')
      expect(scriptManager).toBeDefined()
      @

    describe "#ScriptManager Instance", ()->
      scriptManager = null

      beforeEach ()->
        scriptManager = ScriptManager.create(apiKey : apiKey)
        @

      it "should have options property", ()->
        expect(scriptManager.options).toBeDefined()
        @

      it "set default value to options ", ()->
        expect(scriptManager.options.consumerKey).toBe("anonymous")
        expect(scriptManager.options.consumerSecret).toBe("anonymous")
        expect(scriptManager.options.oauthName).toBe("ScriptManager")
        @

      it "does not set options's properties, if they are already set",()->
        scriptManager = ScriptManager.create(
          apiKey : apiKey
          consumerKey : "consumerKey"
          consumerSecret : "consumerSecret"
          oauthName : "oauthName"
        )

        expect(scriptManager.options.consumerKey).toBe("consumerKey")
        expect(scriptManager.options.consumerSecret).toBe("consumerSecret")
        expect(scriptManager.options.oauthName).toBe("oauthName")
        @

      describe "#getProject method",()->

        it "should throw error, if does not set fileId", ()->
          expect(()->scriptManager.getProject()).toThrow "fileId is requiered"
          @

        it "should get GASProject instance",()->
          project = scriptManager.getProject(fileId)
          expect(project).toBeDefined()
          expect(project.fileId).toBe fileId
          @
        @
      describe "#createProject method", ()->

        it "should create empty project", ()->
          project = scriptManager.createProject()
          expect(project).toBeDefined()
          expect(project.fileId).toBeNull()
          expect(project.filename).toBeUndefined()
          @

        it "can set project name", ()->
          project = scriptManager.createProject("filename")
          expect(project).toBeDefined()
          expect(project.fileId).toBeNull()
          expect(project.filename).toBe("filename")
          @
        @
      @
    @
  @

