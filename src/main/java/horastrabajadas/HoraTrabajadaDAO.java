package horastrabajadas;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import exceptions.DAOException;
import utils.ConexionDB;

public class HoraTrabajadaDAO {
	public void insert(HoraTrabajada hora) throws DAOException {
        String sql = "INSERT INTO hora_trabajada (idTarea, idEmpleado, fecha, cantidad) VALUES (?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, hora.getIdTarea());
            ps.setInt(2, hora.getIdEmpleado());
            ps.setTimestamp(3, new java.sql.Timestamp(hora.getFecha().getTime()));
            ps.setInt(4, hora.getCantidad());
            ps.executeUpdate();

        } catch (SQLException e) {
        	throw new DAOException("Error al insertar horas en la tarea: "+ hora.getIdTarea(), e);
        }
    }
	public void update(HoraTrabajada hora) throws DAOException {
        String sql = "UPDATE hora_trabajada SET fecha = ?, cantidad = ? WHERE idTarea = ? and idEmpleado = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
        	ps.setInt(1, hora.getIdTarea());
            ps.setInt(2, hora.getIdEmpleado());
            ps.setTimestamp(3, new java.sql.Timestamp(hora.getFecha().getTime()));
            ps.setInt(4, hora.getCantidad());
            ps.executeUpdate();
        } catch (SQLException e) {
        	throw new DAOException("Error al actualizar horas en la tarea: "+ hora.getIdTarea(), e);
        }
    }
	
    public void delete(int idTarea, int idEmpleado) throws DAOException {
        String sql = "DELETE FROM hora_trabajada WHERE idTarea = ? and idEmpleado = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
        	ps.setInt(1, idTarea);
        	ps.setInt(2, idEmpleado);
            ps.executeUpdate();
        } catch (SQLException e) {
        	throw new DAOException("Error al eliminar horas de la tarea con id: " + idTarea, e);
        }
    }
    
    public HoraTrabajada getById(int idTarea, int idEmpleado) throws DAOException {
        String sql = "SELECT * FROM hora_trabajada WHERE idTarea = ? and idEmpleado = ?";
        HoraTrabajada hora = null;

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idTarea);
            ps.setInt(2, idEmpleado);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
            	 hora = new HoraTrabajada();
                 hora.setIdTarea(rs.getInt("idTarea"));
                 hora.setIdEmpleado(rs.getInt("idEmpleado"));
                 Timestamp timestamp = rs.getTimestamp("fecha");
                 if (timestamp != null) {
                     hora.setFecha(new Date(timestamp.getTime()));
                 }
                 hora.setCantidad(rs.getInt("cantidad"));
            }

        } catch (SQLException e) {
            throw new DAOException("Error al recuperar la hora con idTarea: " + idTarea + "y idEmpleado: " + idEmpleado, e);
        }

        return hora;
    }
    public List<HoraTrabajada> getAll() throws DAOException {
        String sql = "SELECT * FROM hora_trabajada";
        List<HoraTrabajada> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
            	HoraTrabajada hora = new HoraTrabajada();
                hora.setIdTarea(rs.getInt("idTarea"));
                hora.setIdEmpleado(rs.getInt("idEmpleado"));
                Timestamp timestamp = rs.getTimestamp("fecha");
                if (timestamp != null) {
                    hora.setFecha(new Date(timestamp.getTime()));
                }
                hora.setCantidad(rs.getInt("cantidad"));
                lista.add(hora);
            }

        } catch (SQLException e) {
        	throw new DAOException("Error al obtener todas las horas trabajadas", e);
        }

        return lista;
    }
}
