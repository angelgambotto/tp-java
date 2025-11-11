package comentarios;

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

public class ComentarioDAO {
	public void insert(Comentario com) throws DAOException {
        String sql = "INSERT INTO comentario (idTarea, idAutor, fecha, texto) VALUES (?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, com.getIdTarea());
            ps.setInt(2, com.getIdEmpleado());
            ps.setTimestamp(3, new java.sql.Timestamp(com.getFecha().getTime()));
            ps.setString(4, com.getTexto());
            ps.executeUpdate();

        } catch (SQLException e) {
        	throw new DAOException("Error al insertar comentario en la tarea: "+ com.getIdTarea(), e);
        }
    }
	
	public void update(Comentario com) throws DAOException {
        String sql = "UPDATE comentario SET fecha = ?, texto = ? WHERE idTarea = ? and idAutor = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
        	ps.setInt(1, com.getIdTarea());
            ps.setInt(2, com.getIdEmpleado());
            ps.setTimestamp(3, new java.sql.Timestamp(com.getFecha().getTime()));
            ps.setString(4, com.getTexto());
            ps.executeUpdate();
        } catch (SQLException e) {
        	throw new DAOException("Error al actualizar comentario en la tarea: "+ com.getIdTarea(), e);
        }
    }
	
	public void delete(int idTarea, int idEmpleado, Date fecha) throws DAOException {
        String sql = "DELETE FROM comentario WHERE idTarea = ? and idAutor = ? and fecha = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
        	ps.setInt(1, idTarea);
        	ps.setInt(2, idEmpleado);
        	//ps.setTimestamp(3, new java.sql.Timestamp(fecha));
            ps.executeUpdate();
        } catch (SQLException e) {
        	throw new DAOException("Error al eliminar horas de la tarea con id: " + idTarea, e);
        }
    }
	
	public Comentario getById(int idTarea, int idEmpleado, Date fecha) throws DAOException {
        String sql = "SELECT * FROM comentario WHERE idTarea = ? and idEmpleado = ? and fecha = ?";
        Comentario com = null;

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idTarea);
            ps.setInt(2, idEmpleado);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
            	 com = new Comentario();
                 com.setIdTarea(rs.getInt("idTarea"));
                 com.setIdEmpleado(rs.getInt("idAutor"));
                 Timestamp timestamp = rs.getTimestamp("fecha");
                 if (timestamp != null) {
                     com.setFecha(new Date(timestamp.getTime()));
                 }
                 com.setTexto(rs.getString("texto"));
            }

        } catch (SQLException e) {
            throw new DAOException("Error al recuperar el comentario con idTarea: " + idTarea + "y idEmpleado: " + idEmpleado + "para la fecha: "+ fecha, e);
        }

        return com;
    }
	
    public List<Comentario> getAll() throws DAOException {
        String sql = "SELECT * FROM comentario";
        List<Comentario> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
            	Comentario com = new Comentario();
                com.setIdTarea(rs.getInt("idTarea"));
                com.setIdEmpleado(rs.getInt("idAutor"));
                Timestamp timestamp = rs.getTimestamp("fecha");
                if (timestamp != null) {
                    com.setFecha(new Date(timestamp.getTime()));
                }
                com.setTexto(rs.getString("texto"));
                lista.add(com);
            }

        } catch (SQLException e) {
        	throw new DAOException("Error al obtener todas las horas trabajadas", e);
        }

        return lista;
    }

	
}
