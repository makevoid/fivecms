PAGES = [
  {
    name: "Home",
    template: "default",
    contents: [
      {
        type: "Text",
        cont: "Welcome to 5CMS!\n\nClick here to edit the contents!\nEasy, huh?",
      },
      {
        type: "Text",
        cont: "See \"the Textile guide\":http://redcloth.org/hobix.com/textile/quick.html and discover all what you can do (text formatting, links, images...)",
      },
      {
        type: "Image",
        cont: "!/images/ruby_logo.png!", # TODO: File.read(image_file)
      },
    ]
  },
  {
    name: "Antani",
    template: "default",
    contents: [
      {
        type: "Text",
        cont: "antani page! \"link test\":#test",
      },
    ]
  },
  {
    name: "Contacts",
    template: "contacts",
    contents: [
      {
        type: "Text",
        cont: "Contact me at: email@example.com",
      },
    ]
  },
]