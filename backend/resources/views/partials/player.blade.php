<div id="music-player" class="fixed-bottom bg-dark-950 border-top border-dark-700 fade-in" style="z-index: 1050; transition: transform 0.3s ease;">
    <style>
        #seek-bar {
            -webkit-appearance: none;
            width: 100%;
            height: 6px;
            background: #495057;
            border-radius: 5px;
            outline: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        #seek-bar::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #fff;
            cursor: pointer;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.8);
            transition: transform 0.1s;
            position: relative;
            z-index: 2;
        }

        #seek-bar:hover::-webkit-slider-thumb {
            transform: scale(1.2);
        }
        
        #seek-bar::-moz-range-thumb {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #fff;
            cursor: pointer;
            border: none;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.8);
            transition: transform 0.1s;
        }

        #seek-bar:hover::-moz-range-thumb {
            transform: scale(1.2);
        }
        
        #seek-bar:focus {
            outline: none;
        }

        #seek-bar:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        @media (max-width: 768px) {
            #music-player {
                padding: 8px 12px !important;
            }
            #music-player .player-desktop {
                display: none !important;
            }
            #music-player .player-mobile {
                display: flex !important;
            }
            #player-cover-mobile {
                width: 48px;
                height: 48px;
            }
            #player-title-mobile {
                font-size: 13px;
                max-width: 120px;
            }
            #player-artist-mobile {
                font-size: 11px;
                max-width: 120px;
            }
        }

        @media (min-width: 769px) {
            #music-player {
                padding: 12px 24px;
            }
            #music-player .player-mobile {
                display: none !important;
            }
            #music-player .player-desktop {
                display: flex !important;
            }
        }
    </style>
    
    <meta name="csrf-token" content="{{ csrf_token() }}">
    
    <div class="container-xxl player-desktop align-items-center justify-content-between">
        <div class="d-flex align-items-center gap-3" style="width: 30%;">
            <img id="player-cover" src="{{ asset('assets/img/logo.png') }}" class="rounded bg-dark-800" width="56" height="56" style="object-fit: cover;">
            <div class="overflow-hidden">
                <h6 id="player-title" class="mb-0 text-truncate fw-bold text-white">Select a song</h6>
                <small id="player-artist" class="text-dark-300 text-truncate d-block">UKM Band</small>
                <small id="loading-status" class="text-warning d-none" style="font-size: 10px;">Loading...</small>
            </div>
        </div>

        <div class="d-flex flex-column align-items-center justify-content-center flex-grow-1 mx-3" style="max-width: 500px;">
            <div class="d-flex align-items-center gap-3 mb-2">
                <button class="btn btn-sm btn-link text-dark-300 hover-text-white" id="shuffle-btn" onclick="toggleShuffle()" title="Shuffle">
                    <i class="bi bi-shuffle"></i>
                </button>
                <button class="btn btn-sm btn-link text-dark-300 hover-text-white" onclick="prevSong()"><i class="bi bi-skip-start-fill fs-4"></i></button>
                <button id="play-pause-btn" class="btn btn-accent rounded-circle p-0 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;" onclick="togglePlay()">
                    <i class="bi bi-play-fill fs-4 ms-1"></i>
                </button>
                <button class="btn btn-sm btn-link text-dark-300 hover-text-white" onclick="nextSong()"><i class="bi bi-skip-end-fill fs-4"></i></button>
                <button class="btn btn-sm btn-link text-dark-300 hover-text-white" id="repeat-btn" onclick="toggleRepeat()" title="Repeat">
                    <i class="bi bi-repeat"></i>
                </button>
            </div>
            <div class="w-100 d-flex align-items-center gap-2">
                <span id="current-time" class="small text-dark-300" style="font-size: 10px; min-width: 35px;">0:00</span>
                <input type="range" id="seek-bar" class="flex-grow-1" min="0" value="0" step="0.1">
                <span id="duration" class="small text-dark-300" style="font-size: 10px; min-width: 35px;">0:00</span>
            </div>
        </div>

        <div class="d-flex align-items-center justify-content-end gap-3" style="width: 30%;">
           <div class="d-flex align-items-center gap-2" style="width: 120px;">
                <button class="btn btn-sm btn-link text-dark-300 hover-text-white p-0" onclick="toggleMute()" id="mute-btn">
                    <i class="bi bi-volume-up"></i>
                </button>
                <input type="range" id="volume-bar" class="form-range" min="0" max="1" step="0.1" value="1" onchange="setVolume()">
            </div>
        </div>
    </div>

    <div class="player-mobile flex-column">
        <div class="d-flex align-items-center justify-content-between w-100 mb-2">
            <div class="d-flex align-items-center gap-2 flex-grow-1 overflow-hidden">
                <img id="player-cover-mobile" src="{{ asset('assets/img/logo.png') }}" class="rounded bg-dark-800" style="object-fit: cover; width: 48px; height: 48px;">
                <div class="overflow-hidden">
                    <div id="player-title-mobile" class="text-truncate fw-bold text-white" style="font-size: 13px;">Select a song</div>
                    <div id="player-artist-mobile" class="text-dark-300 text-truncate" style="font-size: 11px;">UKM Band</div>
                </div>
            </div>
            <div class="d-flex align-items-center gap-1">
                <button class="btn btn-sm btn-link text-dark-300 p-1" id="shuffle-btn-mobile" onclick="toggleShuffle()">
                    <i class="bi bi-shuffle"></i>
                </button>
                <button class="btn btn-sm btn-link text-dark-300 p-1" onclick="prevSong()"><i class="bi bi-skip-start-fill fs-5"></i></button>
                <button id="play-pause-btn-mobile" class="btn btn-accent rounded-circle p-0 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;" onclick="togglePlay()">
                    <i class="bi bi-play-fill fs-5"></i>
                </button>
                <button class="btn btn-sm btn-link text-dark-300 p-1" onclick="nextSong()"><i class="bi bi-skip-end-fill fs-5"></i></button>
                <button class="btn btn-sm btn-link text-dark-300 p-1" id="repeat-btn-mobile" onclick="toggleRepeat()">
                    <i class="bi bi-repeat"></i>
                </button>
            </div>
        </div>
        <div class="d-flex align-items-center gap-2 w-100">
            <span id="current-time-mobile" class="small text-dark-300" style="font-size: 10px; min-width: 30px;">0:00</span>
            <input type="range" id="seek-bar-mobile" class="flex-grow-1" min="0" value="0" step="0.1" style="height: 4px;">
            <span id="duration-mobile" class="small text-dark-300" style="font-size: 10px; min-width: 30px;">0:00</span>
        </div>
    </div>

    <audio id="global-audio"></audio>
</div>

<script>
    let playlist = @json($globalSongs ?? []);
    let currentIndex = -1;
    let isShuffle = false;
    let isRepeat = false;
    let previousVolume = 1;
    let isDragging = false;
    let currentBlobUrl = null;
    let isAudioReady = false;

    const audio = document.getElementById('global-audio');
    
    const playBtn = document.getElementById('play-pause-btn');
    const cover = document.getElementById('player-cover');
    const title = document.getElementById('player-title');
    const artist = document.getElementById('player-artist');
    const seekBar = document.getElementById('seek-bar');
    const currentTimeEl = document.getElementById('current-time');
    const durationEl = document.getElementById('duration');
    const shuffleBtn = document.getElementById('shuffle-btn');
    const repeatBtn = document.getElementById('repeat-btn');
    const muteBtn = document.getElementById('mute-btn');
    const volumeBar = document.getElementById('volume-bar');
    const loadingStatus = document.getElementById('loading-status');

    const playBtnMobile = document.getElementById('play-pause-btn-mobile');
    const coverMobile = document.getElementById('player-cover-mobile');
    const titleMobile = document.getElementById('player-title-mobile');
    const artistMobile = document.getElementById('player-artist-mobile');
    const seekBarMobile = document.getElementById('seek-bar-mobile');
    const currentTimeElMobile = document.getElementById('current-time-mobile');
    const durationElMobile = document.getElementById('duration-mobile');
    const shuffleBtnMobile = document.getElementById('shuffle-btn-mobile');
    const repeatBtnMobile = document.getElementById('repeat-btn-mobile');

    function setQueue(newSongs) {
        playlist = newSongs;
        currentIndex = -1;
    }

    function playPlaylist(songs) {
        if (!songs || songs.length === 0) return;
        setQueue(songs);
        playSong(songs[0].id);
    }

    function playSong(id) {
        const index = playlist.findIndex(s => s.id == id);
        if (index !== -1) {
            currentIndex = index;
            loadSong(playlist[currentIndex]);
            recordPlay(playlist[currentIndex].id);
        } else {
            const global = @json($globalSongs ?? []);
            const globalIndex = global.findIndex(s => s.id == id);
            if (globalIndex !== -1) {
                playlist = global;
                currentIndex = globalIndex;
                loadSong(playlist[currentIndex]);
                recordPlay(playlist[currentIndex].id);
            }
        }
    }

    function loadSong(song) {
        title.innerText = song.title;
        artist.innerText = song.artist;
        cover.src = "{{ asset('') }}" + song.cover_path;
        titleMobile.innerText = song.title;
        artistMobile.innerText = song.artist;
        coverMobile.src = "{{ asset('') }}" + song.cover_path;
        
        isAudioReady = false;
        loadingStatus.classList.remove('d-none');
        durationEl.innerText = "Loading...";
        durationElMobile.innerText = "...";
        
        audio.src = "{{ asset('') }}" + song.file_path;
        audio.load();

        audio.addEventListener('loadedmetadata', function onMeta() {
            isAudioReady = true;
            seekBar.disabled = false;
            seekBarMobile.disabled = false;
            seekBar.max = audio.duration;
            seekBarMobile.max = audio.duration;
            durationEl.innerText = formatTime(audio.duration);
            durationElMobile.innerText = formatTime(audio.duration);
            loadingStatus.classList.add('d-none');
            updateSeekGradient();
            attemptPlay();
        }, { once: true });

        audio.addEventListener('error', function onError(e) {
            console.error('Audio load error', e);
            loadingStatus.innerText = 'Error';
            loadingStatus.classList.remove('d-none');
        }, { once: true });

        if ('mediaSession' in navigator) {
            navigator.mediaSession.metadata = new MediaMetadata({
                title: song.title,
                artist: song.artist,
                artwork: [{ src: "{{ asset('') }}" + song.cover_path }]
            });
            navigator.mediaSession.setActionHandler('play', togglePlay);
            navigator.mediaSession.setActionHandler('pause', togglePlay);
            navigator.mediaSession.setActionHandler('previoustrack', prevSong);
            navigator.mediaSession.setActionHandler('nexttrack', nextSong);
        }
    }

    function attemptPlay() {
        const playPromise = audio.play();
        if (playPromise !== undefined) {
            playPromise.then(_ => {
                updatePlayBtn(true);
            })
            .catch(error => {
                console.error("Autoplay prevented or interrupted:", error);
                updatePlayBtn(false);
            });
        }
    }
    
    function recordPlay(songId) {
        if (!songId) return;
        fetch(`/songs/${songId}/record-play`, {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                'Content-Type': 'application/json'
            }
        }).catch(err => console.error('Error recording play:', err));
    }

    function togglePlay() {
        if (currentIndex === -1 && playlist.length > 0) {
            playSong(playlist[0].id);
            return;
        }
        if (!isAudioReady) return;
        
        if (audio.paused) {
            attemptPlay();
        } else {
            audio.pause();
            updatePlayBtn(false);
        }
    }

    function updatePlayBtn(isPlaying) {
        playBtn.innerHTML = isPlaying ? '<i class="bi bi-pause-fill fs-4"></i>' : '<i class="bi bi-play-fill fs-4 ms-1"></i>';
        playBtnMobile.innerHTML = isPlaying ? '<i class="bi bi-pause-fill fs-5"></i>' : '<i class="bi bi-play-fill fs-5"></i>';
    }

    function prevSong() {
        if (currentIndex > 0) {
            currentIndex--;
        } else if (isRepeat) {
             currentIndex = playlist.length - 1; 
        } else {
            return; 
        }
        loadSong(playlist[currentIndex]);
        recordPlay(playlist[currentIndex].id);
    }

    function nextSong() {
        if (isShuffle) {
            let nextIndex = Math.floor(Math.random() * playlist.length);
            if (playlist.length > 1 && nextIndex === currentIndex) {
                nextIndex = (nextIndex + 1) % playlist.length;
            }
            currentIndex = nextIndex;
        } else {
            if (currentIndex < playlist.length - 1) {
                currentIndex++;
            } else if (isRepeat) {
                currentIndex = 0; 
            } else {
                return; 
            }
        }
        loadSong(playlist[currentIndex]);
        recordPlay(playlist[currentIndex].id);
    }

    function toggleShuffle() {
        isShuffle = !isShuffle;
        shuffleBtn.classList.toggle('text-accent', isShuffle);
        shuffleBtn.classList.toggle('text-dark-300', !isShuffle);
        shuffleBtnMobile.classList.toggle('text-accent', isShuffle);
        shuffleBtnMobile.classList.toggle('text-dark-300', !isShuffle);
    }

    function toggleRepeat() {
        isRepeat = !isRepeat;
        repeatBtn.classList.toggle('text-accent', isRepeat);
        repeatBtn.classList.toggle('text-dark-300', !isRepeat);
        repeatBtnMobile.classList.toggle('text-accent', isRepeat);
        repeatBtnMobile.classList.toggle('text-dark-300', !isRepeat);
    }

    function toggleMute() {
        if (audio.muted) {
            audio.muted = false;
            volumeBar.value = previousVolume;
            muteBtn.innerHTML = '<i class="bi bi-volume-up"></i>';
            audio.volume = previousVolume;
        } else {
            previousVolume = volumeBar.value;
            audio.muted = true;
            volumeBar.value = 0;
            muteBtn.innerHTML = '<i class="bi bi-volume-mute"></i>';
            audio.volume = 0;
        }
    }

    function setVolume() {
        audio.volume = volumeBar.value;
        if (audio.volume > 0 && audio.muted) {
            audio.muted = false;
             muteBtn.innerHTML = '<i class="bi bi-volume-up"></i>';
        } else if (audio.volume == 0) {
            audio.muted = true;
            muteBtn.innerHTML = '<i class="bi bi-volume-mute"></i>';
        } else if (audio.volume > 0 && !audio.muted) {
            muteBtn.innerHTML = '<i class="bi bi-volume-up"></i>';
        }
    }

    const startDrag = () => { isDragging = true; };
    seekBar.addEventListener('mousedown', startDrag);
    seekBar.addEventListener('touchstart', startDrag);

    const onDrag = () => {
        currentTimeEl.innerText = formatTime(seekBar.value);
        updateSeekGradient();
    };
    seekBar.addEventListener('input', onDrag);

    const endDrag = () => {
        if (!isAudioReady) {
            isDragging = false;
            return;
        }
        const timeToSeek = Number(seekBar.value);
        if (isFinite(timeToSeek) && timeToSeek >= 0 && timeToSeek <= audio.duration) {
            audio.currentTime = timeToSeek;
        }
        isDragging = false;
        updateSeekGradient();
    };
    seekBar.addEventListener('change', endDrag);

    function updateSeekGradient() {
        const value = seekBar.value;
        const max = seekBar.max || 100; 
        const percentage = (value / max) * 100;
        seekBar.style.background = `linear-gradient(to right, var(--accent) ${percentage}%, #495057 ${percentage}%)`;
        seekBarMobile.style.background = `linear-gradient(to right, var(--accent) ${percentage}%, #495057 ${percentage}%)`;
    }

    seekBarMobile.addEventListener('mousedown', startDrag);
    seekBarMobile.addEventListener('touchstart', startDrag);
    seekBarMobile.addEventListener('input', () => {
        currentTimeElMobile.innerText = formatTime(seekBarMobile.value);
        seekBar.value = seekBarMobile.value;
        updateSeekGradient();
    });
    seekBarMobile.addEventListener('change', () => {
        if (!isAudioReady) {
            isDragging = false;
            return;
        }
        const timeToSeek = Number(seekBarMobile.value);
        if (isFinite(timeToSeek) && timeToSeek >= 0 && timeToSeek <= audio.duration) {
            audio.currentTime = timeToSeek;
        }
        isDragging = false;
        updateSeekGradient();
    });

    audio.addEventListener('timeupdate', () => {
        if (!isDragging && isAudioReady) {
            if (isFinite(audio.currentTime)) {
                seekBar.value = audio.currentTime;
                seekBarMobile.value = audio.currentTime;
                currentTimeEl.innerText = formatTime(audio.currentTime);
                currentTimeElMobile.innerText = formatTime(audio.currentTime);
                updateSeekGradient();
            }
        }
    });

    audio.addEventListener('ended', () => {
        nextSong();
    });

    function formatTime(seconds) {
        if (!isFinite(seconds)) return "0:00";
        const min = Math.floor(seconds / 60);
        const sec = Math.floor(seconds % 60);
        return `${min}:${sec < 10 ? '0' : ''}${sec}`;
    }

    window.playSong = playSong;
    window.setQueue = setQueue;
    window.playPlaylist = playPlaylist;
    window.togglePlay = togglePlay;
    window.prevSong = prevSong;
    window.nextSong = nextSong;
    window.toggleShuffle = toggleShuffle;
    window.toggleRepeat = toggleRepeat;
    window.toggleMute = toggleMute;
    window.setVolume = setVolume;
</script>
