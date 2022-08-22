export PROJECT_ROOT="../"
export FLUTTER_PROJECT_ROOT="${PROJECT_ROOT}cipher_ffi_flutter/"
export RUST_PROJECT_ROOT="${PROJECT_ROOT}cipher_ffi_lib/"
export GENERATOR_SOURCE="${RUST_PROJECT_ROOT}/src/api.rs"

export GENERATOR_DESTINATION="${FLUTTER_PROJECT_ROOT}/lib/src/internal_bindings/bridge_generated.dart"

flutter_rust_bridge_codegen -r ${GENERATOR_SOURCE} -d ${GENERATOR_DESTINATION}
cargo ndk -t i686-linux-android -t x86_64-linux-android -t armeabi-v7a -t arm64-v8a build --lib --release
cargo build --lib --release --target x86_64-unknown-linux-gnu
export LIB_NAME="cipher_ffi"



export EXPORT_LINUX_DIR="${FLUTTER_PROJECT_ROOT}libs/linux_x86-64/"
export EXPORT_JNI_DIR="${FLUTTER_PROJECT_ROOT}android/src/main/jniLibs/"

export ANDROID_ARM8_EXPORT_PATH="${EXPORT_JNI_DIR}arm64-v8a/lib_${LIB_NAME}.so"
export ANDROID_ARM7_EXPORT_PATH="${EXPORT_JNI_DIR}armeabi-v7a/lib_${LIB_NAME}.so"
export ANDROID_x86_EXPORT_PATH="${EXPORT_JNI_DIR}x86/lib_${LIB_NAME}.so"
export ANDROID_x86_64_EXPORT_PATH="${EXPORT_JNI_DIR}x86_64/lib_${LIB_NAME}.so"

export LINUX_x86_64_EXPORT_PATH="${EXPORT_LINUX_DIR}lib_${LIB_NAME}.so"

export ANDROID_ARM8_SOURCE_PATH="${RUST_PROJECT_ROOT}target/aarch64-linux-android/release/libcipher_ffi_lib.so"
export ANDROID_ARM7_SOURCE_PATH="${RUST_PROJECT_ROOT}target/armv7-linux-androideabi/release/libcipher_ffi_lib.so"
export ANDROID_x86_SOURCE_PATH="${RUST_PROJECT_ROOT}target/i686-linux-android/release/libcipher_ffi_lib.so"
export ANDROID_x86_64_SOURCE_PATH="${RUST_PROJECT_ROOT}target/x86_64-linux-android/release/libcipher_ffi_lib.so"

export LINUX_x86_64_SOURCE_PATH="${RUST_PROJECT_ROOT}target/x86_64-unknown-linux-gnu/release/libcipher_ffi_lib.so"

mkdir "${EXPORT_JNI_DIR}arm64-v8a/" -p
mkdir "${EXPORT_JNI_DIR}armeabi-v7a/" -p
mkdir "${EXPORT_JNI_DIR}x86/" -p
mkdir "${EXPORT_JNI_DIR}x86_64/" -p

mkdir "${EXPORT_LINUX_DIR}" -p

cp ${ANDROID_ARM8_SOURCE_PATH} ${ANDROID_ARM8_EXPORT_PATH} -f 
cp ${ANDROID_ARM7_SOURCE_PATH} ${ANDROID_ARM7_EXPORT_PATH} -f 
cp ${ANDROID_x86_SOURCE_PATH} ${ANDROID_x86_EXPORT_PATH} -f 
cp ${ANDROID_x86_64_SOURCE_PATH} ${ANDROID_x86_64_EXPORT_PATH} -f 

cp ${LINUX_x86_64_SOURCE_PATH} ${LINUX_x86_64_EXPORT_PATH} -f 
