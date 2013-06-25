/**
 * create a new ScriptManager.
 * @param {object} options required. The option of creating manager. About <code>options</code> property see below.<br/>
 * <pre><code>
 * options = {
 *   apiKey : 'Required. your api key, Please create at https://code.google.com/apis/console/b/0/',
 *   consumerKey : 'Optional. your consumer key of oauth. Default is 'anonymous', Please create at https://code.google.com/apis/console/b/0/.',
 *   consumerSecret : 'Optional. your consumer Secret of oauth. Default is 'anonymous', Please create at https://code.google.com/apis/console/b/0/.',
 *   oauthName : 'Optional. UrlFetch oauth name. Default is 'ScriptManager''
 * }
 * </code></pre>
 * @return {ScriptManager} the Google Apps Script Manager.
 */
function create(options) {
  return new ScriptManager(options);
}

/**
 * Get a project
 * @param {String} fileId the target project file id.
 * @return {GASProject} A Google Apps Script Project.
 */
function getProject(fileId) {
    throw new Error('this is mock function, should not call directly. Please call "create" method before calling this');
}

/**
 * Create an empty project
 * @param {String} projectName project name.
 * @return {GASProject} An empty Google Apps Script Project.
 */

function createProject(projectName) {
    throw new Error('this is mock function, should not call directly. Please call "create" method before calling this');
}