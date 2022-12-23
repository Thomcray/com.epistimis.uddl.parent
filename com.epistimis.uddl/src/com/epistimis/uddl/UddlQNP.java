package com.epistimis.uddl;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;

import com.epistimis.uddl.uddl.ConceptualCharacteristic;
import com.epistimis.uddl.uddl.ConceptualCompositeQuery;
import com.epistimis.uddl.uddl.ConceptualEntity;
import com.epistimis.uddl.uddl.ConceptualQueryComposition;
import com.epistimis.uddl.uddl.LogicalCharacteristic;
import com.epistimis.uddl.uddl.LogicalCompositeQuery;
import com.epistimis.uddl.uddl.LogicalEntity;
import com.epistimis.uddl.uddl.LogicalMeasurement;
import com.epistimis.uddl.uddl.LogicalMeasurementAttribute;
import com.epistimis.uddl.uddl.LogicalQueryComposition;
import com.epistimis.uddl.uddl.PlatformCharacteristic;
import com.epistimis.uddl.uddl.PlatformCompositeQuery;
import com.epistimis.uddl.uddl.PlatformEntity;
import com.epistimis.uddl.uddl.PlatformQueryComposition;
import com.epistimis.uddl.uddl.PlatformStruct;
import com.epistimis.uddl.uddl.PlatformStructMember;

public class UddlQNP  extends DefaultDeclarativeQualifiedNameProvider {
	
	/**
	 * Determine the QualifiedName of obj relative to ctx
	 * @param obj
	 * @param ctx
	 * @return
	 */
	public QualifiedName relativeQualifiedName(EObject obj, EObject ctx) {
		QualifiedName oName = getFullyQualifiedName(obj);
		QualifiedName ctxName = getFullyQualifiedName(ctx);
		
		int maxSegsToCompare = Math.min(oName.getSegmentCount(), ctxName.getSegmentCount());
		int skipSegs = -1;
		for (int i = 0; i < maxSegsToCompare; i++) {
			if (!oName.getSegment(i).equals(ctxName.getSegment(i))) {
				skipSegs = i;
				break;
			}
		}
		// Return only the name back to the common ancestor 
		return oName.skipFirst(skipSegs);		
	}

	/* Conceptual */
	public static QualifiedName qualifiedName(ConceptualCharacteristic obj) {
		ConceptualEntity ce = (ConceptualEntity) obj.eContainer();
		return QualifiedName.create(ce.getName(),obj.getRolename());		
	}

	public static QualifiedName qualifiedName(ConceptualQueryComposition obj) {
		ConceptualCompositeQuery ce = (ConceptualCompositeQuery) obj.eContainer();
		return QualifiedName.create(ce.getName(),obj.getRolename());		
	}
	
	/* Logical */
	public static QualifiedName qualifiedName(LogicalCharacteristic obj) {
		LogicalEntity ce = (LogicalEntity) obj.eContainer();
		return QualifiedName.create(ce.getName(),obj.getRolename());		
	}

	public static QualifiedName qualifiedName(LogicalMeasurementAttribute obj) {
		LogicalMeasurement ce = (LogicalMeasurement) obj.eContainer();
		return QualifiedName.create(ce.getName(),obj.getRolename());		
	}

	public static QualifiedName qualifiedName(LogicalQueryComposition obj) {
		LogicalCompositeQuery ce = (LogicalCompositeQuery) obj.eContainer();
		return QualifiedName.create(ce.getName(),obj.getRolename());		
	}
		
	/* Platform */
	public static QualifiedName qualifiedName(PlatformCharacteristic obj) {
		PlatformEntity ce = (PlatformEntity) obj.eContainer();
		return QualifiedName.create(ce.getName(),obj.getRolename());		
	}
	
	public static QualifiedName qualifiedName(PlatformQueryComposition obj) {
		PlatformCompositeQuery ce = (PlatformCompositeQuery) obj.eContainer();
		return QualifiedName.create(ce.getName(),obj.getRolename());		
	}

	public static QualifiedName qualifiedName(PlatformStructMember obj) {
		PlatformStruct ce = (PlatformStruct) obj.eContainer();
		return QualifiedName.create(ce.getName(),obj.getRolename());		
	}
	

}
