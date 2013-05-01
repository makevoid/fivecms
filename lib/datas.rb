PAGES = [
  {
    name: "Home",
    template: "default",
    contents: [
      {
        type: "Text",
        cont: "Welcome to my site!",
      },
      {
        type: "Image",
        cont: "<binary_image_file>", # TODO: File.read(image_file)
      },
    ]
  },
  {
    name: "Antani",
    template: "default",
    contents: [
      {
        type: "Text",
        cont: "antani page!",
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