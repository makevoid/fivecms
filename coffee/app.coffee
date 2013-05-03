main = (site_data) ->

  # app

  App = Ember.Application.create({
    LOG_TRANSITIONS: true
  })

  # models

  App.Site = Ember.Object.extend({})

  App.ContsController = Ember.ArrayController.extend({})

  App.Content = Ember.Object.extend

    cont_string: Ember.computed(->
      new Handlebars.SafeString textile this.get("cont")
    ).property("cont")

    edit: ->
      this.set "isEditable", true
    saved_cont: ->
      this.set "isEditable", false
      throw "wtf"
      # App.PageView.rerender()

  array = load_site site_data

  site = App.Site.create();
  site.setProperties array[0]
  pages = array[1]

  conts_controller = App.ContsController.create
    content: pages

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
      site

  # App.PageRoute = App.IndexRoute
  App.PageRoute = Em.Route.extend
    model: ->
      site


  # controllers

  App.PageController = Em.ObjectController.extend
    page: current_page
    conts: current_contents
    add: ->
      cont = App.Content.create { cont: "edit me..." }
      this.get('conts').pushObject cont
      cont.edit()

  App.IndexController = App.PageController


  # views

  App.IndexView = Em.View.extend
    layoutName: 'page-layout'

  App.PageView = Em.View.extend
    layoutName: 'page-layout'
    templateName: 'index'

  App.ApplicationView = Em.View.extend
    classNames: ["container"]



$.getJSON "/site.json", (site_data) ->
  main site_data


current_page_name = location.pathname.split("/")[2]

load_object = (object) ->
  page = Em.Object.create({})
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