class AudioRecorder{constructor(){this.state={isRecording:!1,recordingBlobs:[]}
let audioContext
try{window.AudioContext=window.AudioContext||window.webkitAudioContext
navigator.getUserMedia=navigator.getUserMedia||navigator.webkitGetUserMedia
window.URL=window.URL||window.webkitURL
audioContext=new AudioContext()}catch(e){alert('There is no web audio support for this browser. Get the latest version of Google Chrome.')}
const startUserMedia=(stream)=>{const input=audioContext.createMediaStreamSource(stream)
this.recorder=new Recorder(input)}
navigator.mediaDevices.getUserMedia({audio:!0}).then(startUserMedia).catch((e)=>console.log(`No audio: ${e}`))}
isRecording(){return this.state.isRecording}
record(){this.state.isRecording=!0
this.recorder.record()}
stop(){return new Promise((resolve,reject)=>{this.recorder.stop()
this.recorder.exportWAV((blob)=>{this.state.isRecording=!1
this.state.recordingBlobs.push(blob)
resolve(this.getRecordingUrls())})
this.recorder.clear()})}
getRecordingUrls(){return this.state.recordingBlobs.map(blob=>URL.createObjectURL(blob))}}