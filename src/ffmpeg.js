const ffmpeg = require('fluent-ffmpeg');
let ffmpegCommand = ffmpeg();

// TODO: Add Multiple Quality options later
ffmpegCommand = (filePath, outputPath) => { 
    console.log('in ffmpeg!');
    ffmpeg(filePath)
    .size('?x480')
    .audioCodec('aac')
    .audioFrequency(48000)
    .audioBitrate('128k')
    .videoBitrate('1400k')
    // .videoCodec('h264')
    // .addOption('-maxrate 2675k')
    // .addOption('-bufsize 3750k')
    .addOption('-profile:v main') //set H264 profile to main - this means support in modern devices
    .addOption('-crf 20')
    .addOption('-sc_threshold 0')
    .addOption('-g 48')
    .addOption('-keyint_min 48')
    .addOption('-hls_time 4')
    .addOption('-hls_playlist_type vod')
    // .addOption('--hls_segment_filename ./public/Test3/480p_%03d.ts ./public/Test3/480p.m3u8')
    .on('end',() => console.log('Segments Generated'))
    .on('error',(err) => console.log('Ohh, Error!!!' + err))
    .save(outputPath);
}

module.exports = ffmpegCommand;