/*
 * generated by Xtext 2.28.0
 */
package com.epistimis.uddl;


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
public class UddlStandaloneSetup extends UddlStandaloneSetupGenerated {

	public static void doSetup() {
		new UddlStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}