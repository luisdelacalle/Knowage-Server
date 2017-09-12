package it.eng.spagobi.functions.metadata;

// Generated 10-mag-2016 14.47.57 by Hibernate Tools 3.4.0.CR1

import it.eng.spagobi.commons.metadata.SbiHibernateModel;

/**
 * SbiFunctionInputDataset generated by hbm2java
 */
public class SbiFunctionInputDataset extends SbiHibernateModel {

	private SbiFunctionInputDatasetId id;
	private SbiCatalogFunction sbiCatalogFunction;

	public SbiFunctionInputDataset() {
	}

	public SbiFunctionInputDataset(SbiFunctionInputDatasetId id) {
		this.id = id;
	}

	public SbiFunctionInputDatasetId getId() {
		return this.id;
	}

	public void setId(SbiFunctionInputDatasetId id) {
		this.id = id;
	}

	public SbiCatalogFunction getSbiCatalogFunction() {
		return sbiCatalogFunction;
	}

	public void setSbiCatalogFunction(SbiCatalogFunction sbiCatalogFunction) {
		this.sbiCatalogFunction = sbiCatalogFunction;
	}

}