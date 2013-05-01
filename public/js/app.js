(function() {
  var load_object, main;

  $.getJSON("/site.json", function(site_data) {
    return main(site_data);
  });

  load_object = function(object) {
    var key, page, _i, _len, _ref;

    page = Em.Object.create({});
    _ref = _(object).keys();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      page.set(key, object[key]);
    }
    return page;
  };

  main = function(site_data) {
    var App, page, pages, site, _i, _len, _ref;

    App = Ember.Application.create({
      LOG_TRANSITIONS: true
    });
    App.Router.reopen({
      location: 'history'
    });
    App.Router.map(function() {
      return this.route("page", {
        path: "/pages/:page_id"
      }, function() {});
    });
    site = Em.Object.create;
    pages = Em.A();
    _ref = site_data.pages;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      page = _ref[_i];
      page = load_object(page);
      pages.pushObject(page);
    }
    site = Em.Object.create({
      name: site_data.name,
      domain: site_data.domain,
      nav: site_data.nav,
      pages: pages
    });
    App.IndexRoute = Em.Route.extend({
      model: function() {
        return site;
      }
    });
    App.PageRoute = Em.Route.extend({
      model: function() {
        return site;
      }
    });
    App.IndexView = Em.View.extend({
      layoutName: 'page-layout'
    });
    App.PageView = Em.View.extend({
      layoutName: 'page-layout',
      templateName: 'index'
    });
    return App.ApplicationView = Em.View.extend({
      classNames: ["container"]
    });
  };

}).call(this);
