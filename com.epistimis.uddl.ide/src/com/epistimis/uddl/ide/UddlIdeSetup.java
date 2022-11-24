/*
 * generated by Xtext 2.28.0
 */
package com.epistimis.uddl.ide;

import com.epistimis.uddl.UddlRuntimeModule;
import com.epistimis.uddl.UddlStandaloneSetup;
import com.google.inject.Guice;
import com.google.inject.Injector;
import org.eclipse.xtext.util.Modules2;

/**
 * Initialization support for running Xtext languages as language servers.
 */
public class UddlIdeSetup extends UddlStandaloneSetup {

	@Override
	public Injector createInjector() {
		return Guice.createInjector(Modules2.mixin(new UddlRuntimeModule(), new UddlIdeModule()));
	}
	
}