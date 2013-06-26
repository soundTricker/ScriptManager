describe "ScriptManager", ()->
  apiKey = ScriptProperties.getProperty("apiKey")

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

  @

