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
      cont_string: Ember.computed(function() {
        return new Handlebars.SafeString(textile(this.get("cont")));
      }).property("cont"),
      edit: function() {
        return this.set("isEditable", true);
      },
      saved_cont: function() {
        this.set("isEditable", false);
        throw "wtf";
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
        var cont;

        cont = App.Content.create({
          cont: "edit me..."
        });
        this.get('conts').pushObject(cont);
        return cont.edit();
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
    var page, pages, site, _i, _len, _ref;

    pages = [];
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
    return [site, pages];
  };

  Ember.Handlebars.helper('textile', function(value) {
    return new Handlebars.SafeString(textile(value));
  });

}).call(this);
