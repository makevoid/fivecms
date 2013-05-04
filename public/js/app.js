(function() {
  var State, close_contents, current_page_name, load_object, load_site, main, win;

  State = {};

  State.open = false;

  main = function(site_data) {
    var App, array, content, conts_controller, current_contents, current_page, get_current_page, pages, site, site_controller, _i, _len, _ref;

    App = Ember.Application.create({
      LOG_TRANSITIONS: true
    });
    window.App = App;
    App.Site = Ember.Object.extend();
    App.SiteController = Ember.ObjectController.extend();
    App.ContsController = Ember.ArrayController.extend();
    App.Content = Ember.Object.extend({
      cont_string: Ember.computed(function() {
        return new Handlebars.SafeString(textile(this.get("cont")));
      }).property("cont"),
      edit: function() {
        if (State.open) {
          close_contents();
          State.open = false;
        }
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
    site_controller = App.SiteController.create({
      content: site
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
        return site_controller.get('content');
      }
    });
    App.PageRoute = Em.Route.extend({
      model: function() {
        return site_controller.get('content');
      }
    });
    App.PageController = Em.ObjectController.extend({
      page: current_page,
      conts: current_contents,
      needs: "site",
      add: function() {
        var cont;

        cont = App.Content.create({
          cont: "edit me..."
        });
        this.get('conts').pushObject(cont);
        cont.edit();
        return false;
      },
      site_name_edit: function() {
        return site.set('isEditingSiteName', true);
      },
      site_name_save: function() {
        return site.set('isEditingSiteName', false);
      },
      site_nav_edit: function() {
        return site.set('isEditingNav', true);
      },
      site_nav_save: function() {
        return site.set('isEditingNav', false);
      },
      site_nav_add: function() {
        var page;

        pages = site.get("pages");
        page = Em.Object.create({
          name: "new page...",
          url: "/temp_url"
        });
        return pages.pushObject(page);
      }
    });
    App.IndexController = App.PageController;
    App.IndexView = Em.View.extend({
      layoutName: 'page-layout',
      classNames: ["inner_container"]
    });
    App.PageView = Em.View.extend({
      layoutName: 'page-layout',
      templateName: 'index',
      classNames: ["inner_container"]
    });
    return App.ApplicationView = Em.View.extend({
      classNames: ["container"]
    });
  };

  $.getJSON("/site.json", function(site_data) {
    return main(site_data);
  });

  close_contents = function() {
    var cont, controller, controllers, conts, _i, _len, _results;

    controllers = App.Router.router.currentHandlerInfos;
    controller = _(controllers).find(function(contr) {
      return contr.name === "index" || contr.name === "page";
    });
    conts = controller.handler.controller.get('conts');
    _results = [];
    for (_i = 0, _len = conts.length; _i < _len; _i++) {
      cont = conts[_i];
      _results.push(cont.set("isEditable", false));
    }
    return _results;
  };

  win = $(window);

  win.on("click", function(evt) {
    var has_cont, target;

    target = $(evt.target);
    has_cont = target.parents(".cont").length;
    window.target = target;
    if (!has_cont) {
      if (State.open) {
        close_contents();
      }
      return State.open = true;
    }
  });

  current_page_name = location.pathname.split("/")[2];

  load_object = function(object) {
    var key, page, _i, _len, _ref;

    page = Em.Object.create();
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
