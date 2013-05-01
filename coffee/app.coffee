App = Ember.Application.create({
  LOG_TRANSITIONS: true
})


App.Router.map ->
  this.route "pages", path: "/pages/antani"

site = Em.Object.create
pages = Em.A()

$.getJSON "/site.json", (site_data) ->

  site = Em.Object.create
javascript:void(0)    name:   site_data.name
    domain: site_data.domain
    nav:    site_data.nav

  for page in site_data.pages
    page = Em.Object.create
      name: page.name

    pages.pushObject page


App.Store = DS.Store.extend
  revision: 11,
  adapter: 'DS.FixtureAdapter'


App.IndexRoute = Em.Route.extend
  # setupController: (controller, song) ->
  #   controller.set 'content', "aaa"
  model: ->
    site

Sait = Em.Object.create
  name: "asd"

App.sait = Em.Object.create
  name: "asd"

App.ApplicationController = Ember.Controller.extend
  asd: "asd"
  # asdBinding: "App.sait.name"

Sait.set("name", "asdasdasd")

App.ApplicationView = Em.View.extend
  classNames: ["container"]


# App.IndexView = Em.View.extend
#   classNames: ["container"]