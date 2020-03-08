package org.springframework.samples.petclinic;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import org.apache.tomcat.jdbc.pool.Validator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AmazonAuroraReadOnlyValidator implements Validator {

	private static final Logger LOG = LoggerFactory.getLogger(AmazonAuroraReadOnlyValidator.class);
	private static final int READ_ONLY = 1;

	@Override
	public boolean validate(Connection connection, int validateAction) {
		Statement stmt = null;
		try {
			stmt = connection.createStatement();
			stmt.setQueryTimeout(5); // timeout 5 seconds.

			ResultSet rs = stmt.executeQuery("select @@innodb_read_only");
			int result = 0;
			if (rs.next()) {
				result = rs.getInt(1);
			}
			stmt.close();
			if (result == READ_ONLY) {
				LOG.info("The connection is from read only instance. Validation failed.");
				return false;
			}
			return true;
		} catch (Exception ex) {
			LOG.error(ex.getMessage());
			if (stmt != null) {
				try {
					stmt.close();
				} catch (Exception ignore2) {/* NOOP */}
			}
		}
		return false;
	}

}
