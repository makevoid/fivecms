(function() {
  var current_page_name, load_object, load_site, main;

  main = function(site_data) {
    var App, array, content, conts_controller, current_contents, current_page, get_current_page, pages, site, _i, _len, _ref;

    App = Ember.Application.create({
      LOG_TRANSITIONS: true
    });
    App.Site = Ember.Object.extend({});
    App.ContsController = Ember.ArrayController.extend({});
    App.Content = Ember.Object.extend({
      edit: function() {
        return this.set("isEditable", true);
      }
    });
    array = load_site(site_data);
    site = App.Site.create();
    site.setProperties(array[0]);
    pages = array[1];
    conts_controller = App.ContsController.create({
      content: pages
    });
    get_current_page = function() {
      var pag;

      pag = _(pages).find(function(page) {
        return page.name_url === current_page_name;
      });
      return pag || _(pages).first();
    };
    current_page = get_current_page();
    current_contents = [];
    _ref = current_page.contents;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      content = _ref[_i];
      current_contents.pushObject(App.Content.create(content));
    }
    App.Router.reopen({
      location: 'history'
    });
    App.Router.map(function() {
      return this.route("page", {
        path: "/pages/:page_id"
      });
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
    App.PageController = Em.ObjectController.extend({
      page: current_page,
      conts: current_contents,
      add: function() {
        return this.get('conts').pushObject({
          cont: "change me..."
        });
      }
    });
    App.IndexController = App.PageController;
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

  $.getJSON("/site.json", function(site_data) {
    return main(site_data);
  });

  current_page_name = location.pathname.split("/")[2];

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

  load_site = function(site_data) {
    var content, page, pages, site, string, _i, _j, _len, _len1, _ref, _ref1;

    pages = [];
    _ref = site_data.pages;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      page = _ref[_i];
      _ref1 = page.contents;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        content = _ref1[_j];
        string = new Handlebars.SafeString(textile(content.cont));
        content.cont_string = string;
      }
      page = load_object(page);
      pages.pushObject(page);
    }
    site = Em.Object.create({
      name: site_data.name,
      domain: site_data.domain,
      nav: site_data.nav,
      pages: pages
    });
    return [site, pages];
  };

  Ember.Handlebars.helper('textile', function(value) {
    return new Handlebars.SafeString(textile(value));
  });

}).call(this);
