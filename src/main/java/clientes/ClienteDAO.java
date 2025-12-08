package clientes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import exceptions.DAOException;
import utils.ConexionDB;

public class ClienteDAO {

	    public void insert(Cliente cli) throws DAOException {
	        String sql = "INSERT INTO Cliente (cuitCuil,razonSocial, mail) VALUES (?,?, ?)";

	        try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setString(1, cli.getCuitCuil());
	            ps.setString(2, cli.getRazonSocial());
	            ps.setString(3, cli.getMail());
	            ps.executeUpdate();

	        } catch (SQLException e) {
	        	throw new DAOException("Error al guardar al nuevo cliente: "+ cli.getRazonSocial(), e);
	        }
	    }

	    public void update(Cliente cli) throws DAOException {
	        String sql = "UPDATE Cliente SET razonSocial = ?, mail = ?, cuitCuil = ? WHERE id = ?";

	        try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setString(1, cli.getRazonSocial());
	            ps.setString(2, cli.getMail());
	            ps.setString(3, cli.getCuitCuil());
	            ps.setInt(4, cli.getId());
	            ps.executeUpdate();

	        } catch (SQLException e) {
	            throw new DAOException("Error al actualizar al cliente: "+cli.getRazonSocial(), e);
	        }
	    }

	    public void delete(int id) throws DAOException {
	        String sql = "DELETE FROM Cliente WHERE id = ?";

	        try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, id);
	            ps.executeUpdate();

	        } catch (SQLException e) {
	            throw new DAOException("El cliente no puede eliminarse, posiblemente esté asignado a algun proyecto", e);
	        }
	    }

	    public Cliente getByCuitCuil(String cuitCuil) throws DAOException {
	        String sql = "SELECT * FROM Cliente WHERE cuitCuil = ?";
	        Cliente cli = null;

	        try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setString(1, cuitCuil);
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                cli = new Cliente();
	                cli.setId(rs.getInt("id"));
	                cli.setCuitCuil(rs.getString("cuitCuil"));
	                cli.setRazonSocial(rs.getString("razonSocial"));
	                cli.setMail(rs.getString("mail"));
	            }

	        } catch (SQLException e) {
	            throw new DAOException("Error al obtener al cliente con cuit/cuil: " + cuitCuil, e);
	        }

	        return cli;
	    }

	    public List<Cliente> getAll() throws DAOException {
	        String sql = "SELECT * FROM Cliente";
	        List<Cliente> lista = new ArrayList<>();

	        try (Connection con = ConexionDB.getConexion();
	             Statement st = con.createStatement();
	             ResultSet rs = st.executeQuery(sql)) {

	            while (rs.next()) {
	                Cliente cli = new Cliente();
	                cli.setId(rs.getInt("id"));
	                cli.setCuitCuil(rs.getString("cuitCuil"));
	                cli.setRazonSocial(rs.getString("razonSocial"));
	                cli.setMail(rs.getString("mail"));
	                lista.add(cli);
	            }

	        } catch (SQLException e) {
	            throw new DAOException("Error al obtener a todos los clientes", e);
	        }

	        return lista;
	    }
	    
	    public Cliente getOne(int id) throws DAOException {
	        String sql = "SELECT * FROM Cliente WHERE id = ?";
	        Cliente cli = null;

	        try (Connection con = ConexionDB.getConexion();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, id);
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                cli = new Cliente();
	                cli.setId(rs.getInt("id"));
	                cli.setCuitCuil(rs.getString("cuitCuil"));
	                cli.setRazonSocial(rs.getString("razonSocial"));
	                cli.setMail(rs.getString("mail"));
	            }

	        } catch (SQLException e) {
	        	throw new DAOException("Error al obtener al cliente con id: " + id, e);
	        }

	        return cli;
	    } 
	}
