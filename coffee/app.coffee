State = {}
State.open = false


main = (site_data) ->

  # app

  App = Ember.Application.create({
    LOG_TRANSITIONS: true
  })

  window.App = App

  # models

  App.Site = Ember.Object.extend()

  App.SiteController = Ember.ObjectController.extend()

  App.ContsController = Ember.ArrayController.extend()

  App.Content = Ember.Object.extend

    cont_string: Ember.computed(->
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
  site.setProperties array[0]
  pages = array[1]

  conts_controller = App.ContsController.create
    content: pages

  site_controller = App.SiteController.create
    content: site

  # utils

  get_current_page = ->
    pag = _(pages).find (page) ->
      page.name_url == current_page_name
    pag || _(pages).first()

  current_page = get_current_page()

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
    add: ->
      cont = App.Content.create { cont: "edit me..." }
      this.get('conts').pushObject cont
      cont.edit()
      false
    site_name_edit: ->
      site.set 'isEditingSiteName', true
    site_name_save: ->
      site.set 'isEditingSiteName', false
    site_nav_edit: ->
      site.set 'isEditingNav', true
    site_nav_save: ->
      site.set 'isEditingNav', false
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



$.getJSON "/site.json", (site_data) ->
  main site_data


close_contents = ->
  controllers = App.Router.router.currentHandlerInfos
  controller = _(controllers).find (contr) -> contr.name == "index" || contr.name == "page"
  conts = controller.handler.controller.get('conts')
  for cont in conts
    cont.set "isEditable", false

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
Ember.Handlebars.helper 'textile', (value) ->
  new Handlebars.SafeString(textile value)