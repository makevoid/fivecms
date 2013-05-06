unless $ # testing resets that dont belong here
  $ = {}
  $.getJSON = ->

  localStorage = {}
  window = this
  location = {}
  location.pathname = "/"

main = (site_data) ->
  $("body").addClass "editing"

  # app

  App = Em.Application.create({
    LOG_TRANSITIONS: true
  })

  window.App = App

  # store

  # App.store = DS.Store.create
  #   revision: 12,
  #   adapter: DS.LSAdapter.create()


  # models

  App.Site = Em.Object.extend()

  App.SiteController = Em.ObjectController.extend()

  App.ContsController = Em.ArrayController.extend()

  App.Content = Em.Object.extend

    cont_string: Em.computed(->
      new Handlebars.SafeString textile this.get("cont")
    ).property("cont")

    edit: ->
      if State.open
        close_contents()
        State.open = false
      this.set "isEditable", true
    saved_cont: ->
      this.set "isEditable", false
      throw "wtf"
      # App.PageView.rerender()

  array = load_site site_data

  site = App.Site.create()
  # TODO: put contents under site
  site.addObserver 'name', ->
    # TODO: serialize (json) and restore site state
    console.log "name changed "

  window.site = site
  site.setProperties array[0]
  pages = array[1]

  conts_controller = App.ContsController.create
    content: pages

  site_controller = App.SiteController.create
    content: site

  current_page = get_current_page(pages)

  current_contents = []
  for content in current_page.contents
    current_contents.pushObject App.Content.create content


  # router

  App.Router.reopen
    location: 'history'

  App.Router.map ->
    this.route "page", path: "/pages/:page_id"


  # routes

  App.IndexRoute = Em.Route.extend
    model: ->
      site_controller.get 'content'

  # App.PageRoute = App.IndexRoute
  App.PageRoute = Em.Route.extend
    model: ->
      site_controller.get 'content'


  # controllers

  App.PageController = Em.ObjectController.extend
    page: current_page
    conts: current_contents
    needs: "site"
    init: ->
      site.set "name", storage.site_name
    add: ->
      cont = App.Content.create { cont: "edit me..." }
      this.get('conts').pushObject cont
      cont.edit()
      false
    site_name_edit: ->
      site.set 'isEditingSiteName', true
    site_name_save: ->
      site.set 'isEditingSiteName', false
      storage.site_name = site.get 'name'
    site_nav_edit: ->
      site.set 'isEditingNav', true
    site_nav_save: ->
      site.set 'isEditingNav', false
      # storage.site_nav = site.get 'nav?'
    site_nav_add: ->
      pages = site.get "pages"
      page = Em.Object.create
        name: "new page..."
        url: "/temp_url"
      pages.pushObject page



  App.IndexController = App.PageController



  # views

  App.IndexView = Em.View.extend
    layoutName: 'page-layout'
    classNames: ["inner_container"]

  App.PageView = Em.View.extend
    layoutName: 'page-layout'
    templateName: 'index'
    classNames: ["inner_container"]

  App.ApplicationView = Em.View.extend
    classNames: ["container"]


  # non ember events

  bind_contents_close()


$.getJSON "/sites/1.json", (site_data) ->
  main site_data


State = {}
State.open = false

storage = localStorage
window.storage = storage
# prepare storage
storage.sites = [] unless storage.sites



get_current_page = (pages) ->
  pag = _(pages).find (page) ->
    page.name_url == current_page_name
  pag || _(pages).first()

close_contents = ->
  controllers = App.Router.router.currentHandlerInfos
  controller = _(controllers).find (contr) -> contr.name == "index" || contr.name == "page"
  conts = controller.handler.controller.get('conts')
  for cont in conts
    cont.set "isEditable", false

bind_contents_close = ->
  win = $(window)
  win.on "click", (evt) ->
    target = $ evt.target
    has_cont = target.parents(".cont").length
    window.target = target
    if !has_cont
      if State.open
        close_contents()

      State.open = true


current_page_name = location.pathname.split("/")[2]

load_object = (object) ->
  page = Em.Object.create()
  for key in _(object).keys()
    page.set key, object[key]
  page

load_site = (site_data) ->
  pages = []

  for page in site_data.pages
    page = load_object page
    pages.pushObject page

  site = Em.Object.create
    name:   site_data.name
    domain: site_data.domain
    nav:    site_data.nav
    pages:  pages

  [site, pages]


# doesn't works
Em.Handlebars.helper 'textile', (value) ->
  new Handlebars.SafeString(textile value)