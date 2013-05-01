$.getJSON "/site.json", (site_data) ->
  main site_data

load_object = (object) ->
  page = Em.Object.create({})
  for key in _(object).keys()
    page.set key, object[key]
  page

main = (site_data) ->
  App = Ember.Application.create({
    LOG_TRANSITIONS: true
  })

  App.Router.reopen
    location: 'history'

  App.Router.map ->
    # this.route "pages", path: "/pages"
    this.route "page", path: "/pages/:page_id", ->

    # this.resource "pages"#, ->


  site = Em.Object.create
  pages = Em.A()

  for page in site_data.pages
    page = load_object page
    pages.pushObject page

  site = Em.Object.create
    name:   site_data.name
    domain: site_data.domain
    nav:    site_data.nav
    pages:  pages

  # routes

  App.IndexRoute = Em.Route.extend
    model: ->
      site

  App.PageRoute = Em.Route.extend
    model: ->
      site

  # views

  App.IndexView = Em.View.extend
    layoutName: 'page-layout'

  App.PageView = Em.View.extend
    layoutName: 'page-layout'
    templateName: 'index'

  App.ApplicationView = Em.View.extend
    classNames: ["container"]


# App.IndexView = Em.View.extend
#   classNames: ["container"]