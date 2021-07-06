


function dataURLtoFile(dataurl, filename) {

  var arr = dataurl.split(','),
    mime = arr[0].match(/:(.*?);/)[1],
    bstr = atob(arr[1]),
    n = bstr.length,
    u8arr = new Uint8Array(n);

  while (n--) {
    u8arr[n] = bstr.charCodeAt(n);
  }
  return new File([u8arr], filename, { type: mime });

}



function uploadFile(dataurl, filename) {
  file = dataURLtoFile(dataurl, filename);
  var uploadedFileData;
  var uppy = Uppy.Core({ autoProceed: true }).use(Uppy.AwsS3, {

    companionUrl: 'https://linkstagram-api.ga', // will call `GET /s3/params` on our app
  })
    .on('upload-success', (file, response) => {
      uploadedFileData = JSON.stringify({
        id: file.meta.key.match(/cache\/(.+)/)[1], // remove the Shrine storage prefix
        storage: 'cache',
        metadata: {
          size: file.size,
          filename: file.name,
          mime_type: file.type,
        }
      })
    window.parent.postMessage(uploadedFileData, "*");

    })
  uppy.on('complete', (result) => {
    console.log('Upload complete! We’ve uploaded these files:', result.successful)
  })
  uppy.addFile({
    source: 'file input',
    name: file.name,
    type: file.type,
    data: file
  });

}