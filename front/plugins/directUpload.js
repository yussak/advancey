import { DirectUpload } from "@rails/activestorage"
 
class DirectUploader {
  constructor(file, url, onProgressCallback) {
    this.file = file
    this.url = url
    this.onProgressCallback = onProgressCallback
    this.directUpload = new DirectUpload(this.file, this.url, this)
  }

  upload(onErrorCallBack, onSuccessCallback) {
    // createメソッドを実行
    this.directUpload.create((error, blob) => {
      if (error) {
        // エラー時の処理
        onErrorCallBack(error, this)
      } else {
        // 成功時の処理
        onSuccessCallback(blob, this)
      }
    })
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress", event => this.directUploadDidProgress(event))
  }

  directUploadDidProgress(event) {
    this.onProgressCallback(event, this)
  }
}

export default DirectUploader