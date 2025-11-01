package usuarios;

import java.sql.*;
import java.util.LinkedList;

import exceptions.DAOException;
import utils.ConexionDB;
public class UsuariosDAO {
	public Usuario buscarParaLogin(String usuario,String clave) throws DAOException {
		Usuario user=null;
		try {
			Connection conn=ConexionDB.getConexion();
			PreparedStatement stmt=conn.prepareStatement("SELECT * FROM usuario where usuario=? and clave=?");
			stmt.setString(1, usuario);
			stmt.setString(2, clave);
			ResultSet rs=stmt.executeQuery();
			if(rs!=null && rs.next()) {
				int idUsuario=rs.getInt("id");
				String nombreUsuario=rs.getString("nombre");
				String apellidoUsuario=rs.getString("apellido");
				String usuarioUsuario=rs.getString("usuario");
				String rolUsuario=rs.getString("rol");
				String mailUsuario=rs.getString("mail");
				String claveUsuario=rs.getString("clave");
				Integer supervisorUsuario=rs.getInt("supervisor");
				user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,claveUsuario,usuarioUsuario,rolUsuario,supervisorUsuario);
				return user;
			}
			if(rs!=null) {
				rs.close();
			}
			if(stmt!=null) {
				stmt.close();
			}
			return user;
			
		}
		catch(SQLException ex){
			throw new DAOException("Error al obtener usuario", ex);
		}
	}
	public LinkedList<Usuario> getPorRol(String rol) throws DAOException{
		LinkedList<Usuario> usuarios=new LinkedList<>();
		try {
			Connection conn=ConexionDB.getConexion();
			PreparedStatement stmt=conn.prepareStatement("SELECT * FROM usuario where rol=?");
			stmt.setString(1,rol);
			ResultSet rs=stmt.executeQuery();
			
			if(rs!=null) {
				while (rs.next()) {
					int idUsuario=rs.getInt("id");
					String nombreUsuario=rs.getString("nombre");
					String apellidoUsuario=rs.getString("apellido");
					String usuarioUsuario=rs.getString("usuario");
					String rolUsuario=rs.getString("rol");
					String mailUsuario=rs.getString("mail");
					Integer supervisorUsuario=rs.getInt("supervisor");
					Usuario user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,"",usuarioUsuario,rolUsuario,supervisorUsuario);
					usuarios.add(user);
				}
			}
			if(rs!=null) {rs.close();
			}
				if(stmt!=null) {
					stmt.close();
				}
				conn.close();
		}
		catch(SQLException e) {
			throw new DAOException("Error al obtener los usuarios por rol: " + rol,e);
		}
		return usuarios;
	}
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
				String usuarioUsuario=rs.getString("usuario");
				String rolUsuario=rs.getString("rol");
				String mailUsuario=rs.getString("mail");
				Integer supervisorUsuario=rs.getInt("supervisor");
				Usuario user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,"",usuarioUsuario,rolUsuario,supervisorUsuario);
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
				String usuarioUsuario=rs.getString("usuario");
				Integer supervisorUsuario=rs.getInt("supervisor");
				String rolUsuario=rs.getString("rol");
				String mailUsuario=rs.getString("mail");
				user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,"",usuarioUsuario,rolUsuario,supervisorUsuario);
	
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
			stmt=conn.prepareStatement("insert into usuario (nombre,apellido,rol,usuario,mail,clave,supervisor) VALUES(?,?,?,?,?,?,?)",PreparedStatement.RETURN_GENERATED_KEYS);
			stmt.setString(1,user.getNombre());
			stmt.setString(2, user.getApellido());
			stmt.setString(3, user.getRol());
			stmt.setString(4, user.getUsuario());
			stmt.setString(5, user.getMail());
			stmt.setString(6, user.getClave());
			if (user.getSupervisor() != null) {
			    stmt.setInt(7, user.getSupervisor());
			} else {
			    stmt.setNull(7, java.sql.Types.INTEGER);
			}
			stmt.executeUpdate();
			rs=stmt.getGeneratedKeys();
			if(rs!=null && rs.next()) {
				user.setId(rs.getInt(1));
				
				
			}
			if(rs!=null) {
				rs.close();
			}
			if(stmt!=null) {
				stmt.close();
			}
			
		}
		catch(SQLException e) {
			throw new DAOException("Error al agregar al usuario: " + user.getMail(),e);
		}
		
	}
	public void update(Usuario user) throws DAOException {
		PreparedStatement stmt=null;
		try {
			Connection conn=ConexionDB.getConexion();
			stmt=conn.prepareStatement("Update usuario set nombre=?,apellido=?,clave=?,usuario=?,rol=?,mail=?,supervisor=? where id=?");
			stmt.setString(1,user.getNombre());
			stmt.setString(2, user.getApellido());
			stmt.setString(3,user.getClave());
			stmt.setString(4, user.getUsuario());
			stmt.setString(5,user.getRol());
			stmt.setString(6, user.getMail());
			if (user.getSupervisor() != null) {
			    stmt.setInt(7, user.getSupervisor());
			} else {
			    stmt.setNull(7, java.sql.Types.INTEGER);
			}
			stmt.setInt(8, user.getId());
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



