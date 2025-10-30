package usuarios;

import java.sql.*;
import java.util.LinkedList;

import exceptions.DAOException;
import utils.ConexionDB;
public class UsuariosDAO {

	public LinkedList<Usuario> getAll() throws DAOException{
		LinkedList<Usuario> usuarios=new LinkedList<>();
		
		try {
			Connection conn=ConexionDB.getConexion();
			Statement stmt=conn.createStatement();
			ResultSet rs=stmt.executeQuery("SELECT * FROM usuario");
			if(rs!=null) {
			while(rs.next()) {
				
				int idUsuario=rs.getInt("id");
				String nombreUsuario=rs.getString("nombre");
				String apellidoUsuario=rs.getString("apellido");
				String supervisorUsuario=rs.getString("usuario");
				String rolUsuario=rs.getString("rol");
				String mailUsuario=rs.getString("mail");
				Usuario user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,"",supervisorUsuario,rolUsuario);
				usuarios.add(user);
			}}
			if(rs!=null) {rs.close();
			}
				if(stmt!=null) {
					stmt.close();
				}
				conn.close();	
		}
		catch(SQLException e) {
			throw new DAOException("Error al obtener todos los usuarios", e);
		}
		return usuarios;
	}
	public Usuario getOne(int id) throws DAOException{
		Usuario user=null;
		try {
			Connection conn=ConexionDB.getConexion();
			PreparedStatement stmt=conn.prepareStatement("SELECT * FROM usuario where id=?");
			stmt.setInt(1,id);
			ResultSet rs=stmt.executeQuery();
			if(rs!=null && rs.next()) {
				int idUsuario=rs.getInt("id");
				String nombreUsuario=rs.getString("nombre");
				String apellidoUsuario=rs.getString("apellido");
				String supervisorUsuario=rs.getString("usuario");
				String rolUsuario=rs.getString("rol");
				String mailUsuario=rs.getString("mail");
				user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,"",supervisorUsuario,rolUsuario);
	
			}
			if(rs!=null) {
				rs.close();
			}
			if(stmt!=null) {
				stmt.close();
			}
		}
			
		
		catch(SQLException e) {
			throw new DAOException("Error al obtener el usuario con id: " + id, e);
		}
		return user;
	}
	public void add(Usuario user) throws DAOException {
		
		PreparedStatement stmt=null;
		ResultSet rs=null;
		try {	
			Connection conn=ConexionDB.getConexion();
			stmt=conn.prepareStatement("insert into usuario (nombre,apellido,rol,usuario,mail,clave) VALUES(?,?,?,?,?,?)",PreparedStatement.RETURN_GENERATED_KEYS);
			stmt.setString(1,user.getNombre());
			stmt.setString(2, user.getApellido());
			stmt.setString(3, user.getRol());
			stmt.setString(4, user.getUsuario());
			stmt.setString(5, user.getMail());
			stmt.setString(6, user.getClave());
			stmt.executeUpdate();
			rs=stmt.getGeneratedKeys();
			if(rs!=null && rs.next()) {
				user.setId(rs.getInt("id"));
				
				
			}
			if(rs!=null) {
				rs.close();
			}
			if(stmt!=null) {
				stmt.close();
			}
			
		}
		catch(SQLException e) {
			throw new DAOException("Error al agregar al usuario: " + user.getMail());
		}
		
	}
	public void update(Usuario user) throws DAOException {
		PreparedStatement stmt=null;
		try {
			Connection conn=ConexionDB.getConexion();
			stmt=conn.prepareStatement("Update usuario set nombre=?,apellido=?,clave=?,usuario=?,rol=?,mail=? where id=?");
			stmt.setString(1,user.getNombre());
			stmt.setString(2, user.getApellido());
			stmt.setString(3,user.getClave());
			stmt.setString(4, user.getUsuario());
			stmt.setString(5,user.getRol());
			stmt.setString(6, user.getMail());
			stmt.setInt(7, user.getId());
			stmt.executeUpdate();
		}
		catch(SQLException e) {
			throw new DAOException("Error al actualizar al usuario: " + user.getMail());
		}
	}
	public void delete(int idABorrar) throws DAOException {
		PreparedStatement stmt=null;
		try {
			Connection conn=ConexionDB.getConexion();
			stmt=conn.prepareStatement("DELETE from usuario where id=?");
				stmt.setInt(1, idABorrar);
				stmt.executeUpdate();
			}
			catch(SQLException e) {
				throw new DAOException("Error al eliminar al usuario con id: " + idABorrar, e);
			}
	}
}



