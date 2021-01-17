const express = require('express');
const cors = require('cors');
const ffmpegCommand = require('./ffmpeg');

const multer = require('multer');

// TODO: Implement ffmpeg and IPFS Storage
const app = express();

// To parse the json data
app.use(express.json({limit: '500mb'}));
// To prevent Access-allow-control-origin error from chrome
app.use(cors());

// TODO: Add folder creation for each video to host their video and streams
let storage = multer.diskStorage({
  destination: function(req, file, cb){
    cb(null, './uploads');
  },
  filename: function(req, file, cb) {
    cb(null, file.originalname);
  }
});

const upload = multer({storage: storage})

app.post('/fileUpload', upload.single('video'), (req, res, next) => {    

    console.log('Video name:', req.file.originalname);
    console.log('Video title:', req.body.title);
    console.log('Video Description:', req.body.description);
    // TODO: Implement ffmpeg here
    // As the post request is executed only when multer is completed, no need to check if the file is already uploaded or not.
    // const filePath = './uploads/' + req.file.originalname;
    // const outputPath = './streams/' + req.body.title;
    // ffmpegCommand(filePath, outputPath);
    // try {
    //   res.send(req.file);
    // }catch(err) {
    //   res.send(400);
    // }
});


app.listen(3001, () => console.log('app is running on port 3001'));

