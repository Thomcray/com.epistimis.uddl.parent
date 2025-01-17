package com.epistimis.uddl.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
//import org.example.smalljava.SmallJavaModelUtil
//import org.example.smalljava.smallJava.SJMemberSelection
//import org.example.smalljava.smallJava.SJMethod
//import org.example.smalljava.smallJava.SJProgram
//import org.example.smalljava.smallJava.SJSymbolRef
//import org.example.smalljava.smallJava.SJVariableDeclaration
import com.epistimis.uddl.uddl.UddlPackage
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static extension org.junit.jupiter.api.Assertions.assertEquals
import com.epistimis.uddl.uddl.DataModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtext.testing.extensions.InjectionExtension

@ExtendWith(InjectionExtension)
@InjectWith(UddlInjectorProvider)
class UddlScopeProviderTest {
	@Inject extension ParseHelper<DataModel>
	@Inject extension IScopeProvider

	/**
	 * Read in the UDDL SDM into a resource. Then add to that simple models that 
	 */
	static ResourceSet testRS;
	static Resource uddlSDM;

	def static initializeSDM() {
		val uri = URI.createFileURI("UDDL_SDM_Min.uddl");
		testRS = new ResourceSetImpl();
		uddlSDM = testRS.getResource(uri, true);

	}

	/* 
	 * 	@Test def void testScopeProvider() {
	 * 		'''
	 * dm DataModel  {
	 * 	cdm Conceptual  {
	 * 				cdm Identifier {
	 * 					observable Identifier "Distinguishes an item from other items.  The uniqueness of this identifier should be quantified in the realized measurement.  Identifiers may best be used in the context of an association to capture how one associated entity refers to another. " ;
	 * 				}
	 * 	  cdm Observables {
	 * 		observable NonPhysicalAddress "A scheme applied over a non-physical location/space used to delineate different elements or parts (e.g. IPv4, IPv4, telephone number)." ;
	 * 	  }
	 * 	}
	 * }
	 * 		'''.parse.classes.head.methods.last.returnStatement.expression => [
	 * 			assertScope(UddlPackage.eINSTANCE.SJMemberSelection_Member, "f, m, C.f, C.m")
	 * 			assertScope(UddlPackage.eINSTANCE.SJSymbolRef_Symbol, "v, p")
	 * 		]
	 * 	}

	 * 	@Test def void testScopeProviderForSymbols() {
	 * 		'''
	 * 			class C {
	 * 			  A m(A p) {
	 * 			    A v1 = null;
	 * 			    if (true) {
	 * 			      A v2 = null;
	 * 			      A v3 = null;
	 * 			    }
	 * 			    A v4 = null;
	 * 			    return null;
	 * 			  }
	 * 			}
	 * 			class A {}
	 * 		'''.parse.classes.head.methods.last.body.eAllContents.filter(SJVariableDeclaration) => [
	 * 			findFirst[name == 'v3'].expression.assertScope(UddlPackage.eINSTANCE.SJSymbolRef_Symbol, "v2, v1, p")
	 * 			findFirst[name == 'v4'].expression.assertScope(UddlPackage.eINSTANCE.SJSymbolRef_Symbol, "v1, p")
	 * 		]
	 * 	}

	 * 	@Test def void testVariableShadowsParamScoping() {
	 * 		'''
	 * 		class C {
	 * 			A m(A a) {
	 * 				A a = null;
	 * 				return a;
	 * 			}
	 * 		}
	 * 		class A {}
	 * 		'''.parse.classes.head.methods.head => [
	 * 			returnStatement.expression.assertScope
	 * 				(UddlPackage.eINSTANCE.SJSymbolRef_Symbol, 
	 * 				"a")
	 * 		]
	 * 	}

	 * 	@Test def void testVariableShadowsParamLinking() {
	 * 		'''
	 * 		class A {
	 * 			A m(A a) {
	 * 				A a = null;
	 * 				return a;
	 * 			}
	 * 		}
	 * 		'''.parse.classes.head.methods.head => [
	 * 			// the local variable should shadow the param
	 * 			body.statements.head.assertSame(
	 * 				(returnStatement.expression as SJSymbolRef).symbol)
	 * 		]
	 * 	}

	 * 	@Test def void testFieldsScoping() {
	 * 		'''
	 * 		class C { 
	 * 			C a;
	 * 		}
	 * 		
	 * 		class D extends C {
	 * 			C b;
	 * 			C m(C p1, D p2) { return this.b; }
	 * 		}'''.parse.classes.last.methods.get(0).returnStatement.expression.assertScope(
	 * 			UddlPackage.eINSTANCE.SJMemberSelection_Member, "b, m, a")
	 * 		// before custom scoping was: "b, m, C.a, D.b, D.m"
	 * 	}

	 * 	@Test def void testMethodsScoping() {
	 * 		'''
	 * 		class C { 
	 * 			C n() { return null; }
	 * 		}
	 * 		
	 * 		class D extends C {
	 * 			C f;
	 * 			C m() { return this.m(); }
	 * 		}'''.parse.classes.last.methods.get(0).returnStatement.expression.assertScope(
	 * 			UddlPackage.eINSTANCE.SJMemberSelection_Member, "m, f, n")
	 * 		// before custom scoping was: "m, C.n, D.m"
	 * 	}

	 * 	@Test def void testFieldScoping() {
	 * 		'''
	 * 			class A {
	 * 			  D a;
	 * 			  D b;
	 * 			  D c;
	 * 			}
	 * 			
	 * 			class B extends A {
	 * 			  D b;
	 * 			}
	 * 			
	 * 			class C extends B {
	 * 			  D a;
	 * 			  D m() { return this.a; }
	 * 			  D n() { return this.b; }
	 * 			  D p() { return this.c; }
	 * 			}
	 * 			class D {}
	 * 		'''.parse.classes => [
	 * 			// a in this.a must refer to C.a
	 * 			get(2).fields.get(0).assertSame(get(2).methods.get(0).returnExpSel.member)
	 * 			// b in this.b must refer to B.b
	 * 			get(1).fields.get(0).assertSame(get(2).methods.get(1).returnExpSel.member)
	 * 			// c in this.c must refer to A.c
	 * 			get(0).fields.get(2).assertSame(get(2).methods.get(2).returnExpSel.member)
	 * 		]
	 * 	}

	 * 	@Test def void testMethodScoping() {
	 * 		'''
	 * 			class A { 
	 * 				D n() { return null; }
	 * 				D m() { return null; }
	 * 				D o() { return null; }
	 * 			}
	 * 			
	 * 			class B extends A { 
	 * 				D n() { return null; }
	 * 			}
	 * 			
	 * 			class C extends B {
	 * 				D m() { return this.m(); }
	 * 				D p() { return this.n(); }
	 * 				D q() { return this.o(); }
	 * 			}
	 * 			class D {}
	 * 		'''.parse.classes => [
	 * 			// m in this.m() must refer to C.m
	 * 			get(2).methods.get(0).assertSame(get(2).methods.get(0).returnExpSel.member)
	 * 			// n in this.n() must refer to B.n
	 * 			get(1).methods.get(0).assertSame(get(2).methods.get(1).returnExpSel.member)
	 * 			// o in this.o() must refer to B.n
	 * 			get(0).methods.get(2).assertSame(get(2).methods.get(2).returnExpSel.member)
	 * 		]
	 * 	}

	 * 	@Test def void testMemberScopeWithUnresolvedReceiver() {
	 * 		'''
	 * 			class C {
	 * 			  A m() {
	 * 			    return foo.m(); // return's expression is the context
	 * 			  }
	 * 			}
	 * 			class A {}
	 * 		'''.parse.classes.head.methods.last.returnStatement.expression => [
	 * 			assertScope(UddlPackage.eINSTANCE.SJMemberSelection_Member, "")
	 * 		]
	 * 	}

	 * 	@Test def void testFieldsAndMethodsWithTheSameName() {
	 * 		'''
	 * 			class C {
	 * 			  A f;
	 * 			  A f() {
	 * 			    return this.f(); // must refer to method f
	 * 			  }
	 * 			  A m() {
	 * 			    return this.m; // must refer to field m
	 * 			  }
	 * 			  A m;
	 * 			}
	 * 			class A {}
	 * 		'''.parse.classes.head => [
	 * 			// must refer to method f()
	 * 			methods.head.assertSame(methods.head.returnExpSel.member)
	 * 			// must refer to field m
	 * 			fields.last.assertSame(methods.last.returnExpSel.member)
	 * 		]
	 * 	}

	 * 	@Test def void testClassesInTheSamePackageInDifferentFiles() {
	 * 		val first = '''
	 * 			package apackage;
	 * 			
	 * 			class B {}
	 * 			class C {}
	 * 		'''.parse
	 * 		val second = '''
	 * 			package apackage;
	 * 			
	 * 			class D {
	 * 			  C c;
	 * 			}
	 * 		'''.parse(first.eResource.resourceSet)
	 * 		'''
	 * 			package anotherpackage;
	 * 			
	 * 			class E {}
	 * 		'''.parse(first.eResource.resourceSet)
	 * 		second.classes.head => [
	 * 			assertScope(UddlPackage.eINSTANCE.SJMember_Type, "D, B, C, apackage.D, apackage.B, apackage.C, anotherpackage.E")
	 * 		]
	 * 	}

	 * 	@Test def void testLocalClassHasThePrecedenceOverTheSameClassInTheSamePackageInDifferentFiles() {
	 * 		val first = '''
	 * 			package apackage;
	 * 			
	 * 			class B {}
	 * 			class C {}
	 * 		'''.parse
	 * 		val second = '''
	 * 			package apackage;
	 * 			
	 * 			class C {
	 * 			  C c;
	 * 			}
	 * 		'''.parse(first.eResource.resourceSet)
	 * 		second.classes.head => [
	 * 			assertScope(UddlPackage.eINSTANCE.SJMember_Type, "C, B, apackage.C, apackage.B")
	 * 			assertSame(fields.head.type)
	 * 		]
	 * 	}

	 * 	def private returnExpSel(SJMethod m) {
	 * 		m.returnStatement.expression as SJMemberSelection
	 * 	}
	 */
	def private assertScope(EObject context, EReference reference, CharSequence expected) {
		expected.toString.assertEquals(context.getScope(reference).allElements.map[name].join(", "))
	}
}
