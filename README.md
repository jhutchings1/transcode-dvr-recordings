# transcode-dvr-recordings

This script automatically transcodes all of the mpeg formatted videos in a DVR's folders to mp4 using [FFmpeg](https://ffmpeg.org). It places the transcoded files into a `finished` directory in case there are errors instead of deleting the old files. You will need to manually delete old files once you are happy with the results.

## Prerequisites

* Powershell
* FFmpeg

## Usage

```powershell
./transcode -path "path/to/directory"
```

## License
This source is available under the MIT License.