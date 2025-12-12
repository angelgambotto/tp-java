package usuarios;

import java.sql.*;
import java.util.LinkedList;

import exceptions.DAOException;
import utils.ConexionDB;
import utils.PasswordUtils;
public class UsuariosDAO {
	public Usuario buscarParaLogin(String usuario, String clave) throws DAOException {
	    Usuario user = null;
	    try (Connection conn = ConexionDB.getConexion()) {
	        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM usuario WHERE usuario = ?");
	        stmt.setString(1, usuario);
	        ResultSet rs = stmt.executeQuery();

	        if (rs != null && rs.next()) {
	            String hashedPassword = rs.getString("clave");
	            String salt = rs.getString("salt");

	            if (PasswordUtils.verifyPassword(clave, hashedPassword, salt)) {
	                user = new Usuario(
	                    rs.getInt("id"),
	                    rs.getString("nombre"),
	                    rs.getString("apellido"),
	                    rs.getString("mail"),
	                    hashedPassword,
	                    rs.getString("usuario"),
	                    rs.getString("rol"),
	                    rs.getInt("supervisor"),
	                    rs.getInt("cliente")
	                );
	            }
	        }
	        rs.close();
	        stmt.close();
	    } catch (SQLException e) {
	        throw new DAOException("Error al obtener usuario", e);
	    }
	    return user;
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
					Integer clienteUsuario = rs.getInt("cliente");
					Usuario user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,"",usuarioUsuario,rolUsuario,supervisorUsuario,clienteUsuario);
					usuarios.add(user);
				}
			}
			if(rs!=null) {
				rs.close();
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
				Integer clienteUsuario = rs.getInt("cliente");
				Usuario user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,"",usuarioUsuario,rolUsuario,supervisorUsuario,clienteUsuario);
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
				Integer clienteUsuario = rs.getInt("cliente");
				user=new Usuario(idUsuario,nombreUsuario,apellidoUsuario,mailUsuario,"",usuarioUsuario,rolUsuario,supervisorUsuario,clienteUsuario);
	
			}
			if(rs!=null) {
				rs.close();
			}
			if(stmt!=null) {
				stmt.close();
			}
			conn.close();
		}
			
		
		catch(SQLException e) {
			throw new DAOException("Error al obtener el usuario con id: " + id, e);
		}
		return user;
	}
	public void add(Usuario user) throws DAOException {
	    try (Connection conn = ConexionDB.getConexion()) {
	        String salt = PasswordUtils.generateSalt();
	        String hashed = PasswordUtils.hashPassword(user.getClave(), salt);

	        PreparedStatement stmt = conn.prepareStatement(
	            "INSERT INTO usuario (nombre, apellido, rol, usuario, mail, clave, salt, supervisor, cliente) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
	            PreparedStatement.RETURN_GENERATED_KEYS
	        );

	        stmt.setString(1, user.getNombre());
	        stmt.setString(2, user.getApellido());
	        stmt.setString(3, user.getRol());
	        stmt.setString(4, user.getUsuario());
	        stmt.setString(5, user.getMail());
	        stmt.setString(6, hashed);
	        stmt.setString(7, salt);
	        if (user.getSupervisor() != null) stmt.setInt(8, user.getSupervisor());
	        else stmt.setNull(8, java.sql.Types.INTEGER);
	        if (user.getIdCliente() != null) stmt.setInt(9, user.getIdCliente());
	        else stmt.setNull(9, java.sql.Types.INTEGER);
	        stmt.executeUpdate();
	        ResultSet rs = stmt.getGeneratedKeys();
	        if (rs != null && rs.next()) user.setId(rs.getInt(1));

	        rs.close();
	        stmt.close();
	    } catch (SQLException e) {
	    	throw new DAOException("Error al agregar al usuario: " + user.getMail(), e);
	    }
	}

	public void update(Usuario user) throws DAOException {
	    try (Connection conn = ConexionDB.getConexion()) {
	        String salt = PasswordUtils.generateSalt();
	        String hashed = PasswordUtils.hashPassword(user.getClave(), salt);

	        PreparedStatement stmt = conn.prepareStatement(
	            "UPDATE usuario SET nombre=?, apellido=?, clave=?, salt=?, usuario=?, rol=?, mail=?, supervisor=?, cliente=? WHERE id=?"
	        );

	        stmt.setString(1, user.getNombre());
	        stmt.setString(2, user.getApellido());
	        stmt.setString(3, hashed);
	        stmt.setString(4, salt);
	        stmt.setString(5, user.getUsuario());
	        stmt.setString(6, user.getRol());
	        stmt.setString(7, user.getMail());
	        if (user.getSupervisor() != null) stmt.setInt(8, user.getSupervisor());
	        else stmt.setNull(8, java.sql.Types.INTEGER);
	        if (user.getIdCliente() != null) stmt.setInt(8, user.getIdCliente());
	        else stmt.setNull(9, java.sql.Types.INTEGER);
	        stmt.setInt(10, user.getId());

	        stmt.executeUpdate();
	        stmt.close();
	    } catch (SQLException e) {
	        throw new DAOException("Error al actualizar usuario: " + user.getMail(), e);
	    }
	}

	public void delete(int idABorrar) throws DAOException {
		PreparedStatement stmt=null;
		try {
			Connection conn=ConexionDB.getConexion();
			stmt=conn.prepareStatement("DELETE from usuario where id=?");
			stmt.setInt(1, idABorrar);
			stmt.executeUpdate();
			conn.close();
		}
		catch(SQLException e) {
			throw new DAOException("El usuario no puede eliminarse, posiblemente hay proyectos donde está asignado", e);
		}
	}
}



