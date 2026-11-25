package com.vineyard.hfm.app.utils;

public class NativeBridge {

    static {
        System.loadLibrary("hfm_native");
    }

    public static native String getContactEndpoint();

    public static native String getQrSecretKey();
}