#include <jni.h>
#include <string>

namespace {
    constexpr unsigned char MASK[4] = {0x5A, 0x33, 0x91, 0xC7};

    std::string decode(const unsigned char* data, size_t len) {
        std::string out(len, '\0');
        for (size_t i = 0; i < len; ++i) {
            out[i] = static_cast<char>(data[i] ^ MASK[i % 4]);
        }
        return out;
    }

    // Contact Formspree Endpoint (XOR-encoded: https://formspree.io/f/xyzenlao)
    constexpr unsigned char CONTACT_ENDPOINT_ENC[] = {
            0x32, 0x47, 0xE5, 0xB7, 0x29, 0x09, 0xBE, 0xE8, 0x3C, 0x5C, 0xE3, 0xAA,
            0x29, 0x43, 0xE3, 0xA2, 0x3F, 0x1D, 0xF8, 0xA8, 0x75, 0x55, 0xBE, 0xBF,
            0x23, 0x49, 0xF4, 0xA9, 0x36, 0x52, 0xFE
    };

    // Internal QR / Session Encryption Key (XOR-encoded: HfmAppSuperSecretKey2026)
    constexpr unsigned char QR_SECRET_KEY_ENC[] = {
            0x12, 0x55, 0xFC, 0x86, 0x2A, 0x43, 0xC2, 0xB2, 0x2A, 0x56, 0xE3, 0x94,
            0x3F, 0x50, 0xE3, 0xA2, 0x2E, 0x78, 0xF4, 0xBE, 0x68, 0x03, 0xA3, 0xF1
    };
}

extern "C" {

JNIEXPORT jstring JNICALL
Java_com_vineyard_hfm_app_utils_NativeBridge_getContactEndpoint(JNIEnv* env, jclass /* clazz */) {
    std::string decoded = decode(CONTACT_ENDPOINT_ENC, sizeof(CONTACT_ENDPOINT_ENC));
    return env->NewStringUTF(decoded.c_str());
}

JNIEXPORT jstring JNICALL
Java_com_vineyard_hfm_app_utils_NativeBridge_getQrSecretKey(JNIEnv* env, jclass /* clazz */) {
    std::string decoded = decode(QR_SECRET_KEY_ENC, sizeof(QR_SECRET_KEY_ENC));
    return env->NewStringUTF(decoded.c_str());
}

}