(function() {
  var App, Sait, pages, site;

  App = Ember.Application.create({
    LOG_TRANSITIONS: true
  });

  App.Router.map(function() {
    return this.route("pages", {
      path: "/pages/antani"
    });
  });

  site = Em.Object.create;

  pages = Em.A();

  $.getJSON("/site.json", function(site_data) {
    var page, _i, _len, _ref, _results;

    site = Em.Object.create({
      name: site_data.name,
      domain: site_data.domain,
      nav: site_data.nav
    });
    _ref = site_data.pages;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      page = _ref[_i];
      page = Em.Object.create({
        name: page.name
      });
      _results.push(pages.pushObject(page));
    }
    return _results;
  });

  App.IndexRoute = Em.Route.extend({
    model: function() {
      return site;
    }
  });

  Sait = Em.Object.create({
    name: "asd"
  });

  App.sait = Em.Object.create({
    name: "asd"
  });

  App.ApplicationController = Ember.Controller.extend({
    asdBinding: "App.sait.name"
  });

  Sait.set("name", "asdasdasd");

  App.ApplicationView = Em.View.extend({
    classNames: ["container"]
  });

}).call(this);
