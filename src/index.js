import { Plugins, CameraResultType } from "@capacitor/core"

require("./index.scss")
require('@ionic/core/loader/index.cjs').defineCustomElements(window)

const app = require("./Main.elm").Elm.Main.init({
  node: document.getElementById("main"),
  flags: null
})

app.ports.getPhoto.subscribe(function (data) {
  Plugins.Camera.getPhoto({
    quality: 90,
    allowEditing: true,
    resultType: CameraResultType.Uri
	}).then(function(photo) {
    app.ports.gotPhoto.send(photo.webPath || '')
  })
})
