set(GS_OPENSSL FALSE)
set(GAMESPY_SERVER_NAME "server.cnc-online.net")

FetchContent_Declare(
    gamespy
    GIT_REPOSITORY https://github.com/zzambers/GamespySDK.git
    GIT_TAG        fixes2
)

FetchContent_MakeAvailable(gamespy)
