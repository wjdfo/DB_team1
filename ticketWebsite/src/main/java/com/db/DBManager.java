package com.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBManager {
    private static Connection connection = null;
    private static final String JDBC_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    //private static final String DB_USER = "concertTicket";
    //private static final String DB_PASSWORD = "concertTicket";
    private static final String DB_USER = "tp";
    private static final String DB_PASSWORD = "comp322";

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                connection = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                throw new SQLException("Failed to establish a database connection.");
            }
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

