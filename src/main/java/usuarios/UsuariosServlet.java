package usuarios;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import exceptions.DAOException;

/**
 * Servlet implementation class UsuariosServlet
 */
@WebServlet("/UsuariosServlet")
public class UsuariosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuariosDAO userDAO;

    @Override
    public void init() {
        userDAO = new UsuariosDAO();
    }

    // ===== Métodos auxiliares =====
    private List<Usuario> cargarUsuariosSeguro(HttpServletRequest request) {
        try {
            return userDAO.getAll();
        } catch (DAOException e) {
            request.setAttribute("error", "No se pudieron cargar los usuarios: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    private Usuario cargarUsuSeguro(HttpServletRequest request, int id) {
        try {
            return userDAO.getOne(id);
        } catch (DAOException e) {
            request.setAttribute("error", "No se pudo cargar el usuario: " + e.getMessage());
            return new Usuario();
        }
    }

    // ===== GET =====
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int idUsuario;
        if (action != null) {
            switch (action) {
                case "new":
                    LinkedList<Usuario> empleados = new LinkedList<>();
                    request.setAttribute("user", null);
                    request.setAttribute("abrirModal", true);
                    try {
                    	empleados = userDAO.getPorRol("Empleado");
                    } catch (DAOException e) {
                        request.setAttribute("error", "No se pudieron cargar los empleados: " + e.getMessage());
                    }
                    System.out.println("empleados: ");						
                    for (Usuario usuario : empleados) {
                    	System.out.println(usuario.getNombreCompleto());
					}
                    request.setAttribute("empleados", empleados);
                    break;

                case "edit":
                    idUsuario = Integer.parseInt(request.getParameter("id"));
                    Usuario u = cargarUsuSeguro(request, idUsuario);
                    if (u != null) {
                        request.setAttribute("user", u);
                        request.setAttribute("abrirModal", true);
                        List<Usuario> supervisoresEdit = new ArrayList<>();
                        for (Usuario s : cargarUsuariosSeguro(request)) {
                            if ("Empleado".equalsIgnoreCase(s.getRol())) {
                                supervisoresEdit.add(s);
                            }
                        }
                        request.setAttribute("empleados", supervisoresEdit);
                    }
                    break;

                case "delete":
                    try {
                        idUsuario = Integer.parseInt(request.getParameter("id"));
                        Usuario usu = cargarUsuSeguro(request, idUsuario);
                        request.setAttribute("user", usu);
                        request.setAttribute("abrirModalEliminar", true);
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "ID de usuario inválido.");
                        request.setAttribute("usuarios", cargarUsuariosSeguro(request));
                        request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
                        return;
                    }
                    break;

                case "signup":
                    // Redirigir a registro público
                    request.getRequestDispatcher("signup.jsp").forward(request, response);
                    return;
            }
        }

        // Cargar usuarios para listado
        List<Usuario> usuarios = cargarUsuariosSeguro(request);

        for (Usuario u : usuarios) {
            if (u.getSupervisor() != null) {
                Usuario supervisor = cargarUsuSeguro(request, u.getSupervisor());
                if (supervisor != null && supervisor.getNombre() != null) {
                    u.setNombreSupervisor(supervisor.getApellido() + ", " + supervisor.getNombre());
                } else {
                    u.setNombreSupervisor("Sin supervisor");
                }
            } else {
                u.setNombreSupervisor("Sin supervisor");
            }
        }
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
    }

    // ===== POST =====
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuarioActual = (Usuario) request.getSession().getAttribute("usuario");
        boolean esAdmin = (usuarioActual != null && "Administrador".equalsIgnoreCase(usuarioActual.getRol()));

        String idReq = request.getParameter("id");
        int id = (idReq == null || idReq.isEmpty()) ? 0 : Integer.parseInt(idReq);
        String action = (request.getParameter("action") != null) ? request.getParameter("action") : "Desconocido";

        // Solo admin puede modificar, excepto signup
        if (!esAdmin && !"signup".equalsIgnoreCase(action)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // ==== REGISTRO PÚBLICO ====
            if ("signup".equalsIgnoreCase(action)) {
                String nombre = request.getParameter("nombre");
                String apellido = request.getParameter("apellido");
                String user = request.getParameter("usuario");
                String mail = request.getParameter("mail");
                String clave = request.getParameter("clave");

                Usuario nuevo = new Usuario(0, nombre, apellido, mail, clave, user, "Usuario", null);
                userDAO.add(nuevo); // se aplica hash + salt en el DAO

                System.out.printf("[INFO] Nuevo usuario registrado: %s (%s)%n", user, mail);
                request.setAttribute("mensaje", "Cuenta creada con éxito. Iniciá sesión.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // ==== ADMIN: ELIMINAR ====
            if (esAdmin && "confirmDelete".equalsIgnoreCase(action)) {
                if (id > 0 && cargarUsuSeguro(request, id) != null) {
                    userDAO.delete(id);
                } else {
                    request.setAttribute("error", "ID de usuario inválido");
                    request.setAttribute("usuarios", cargarUsuariosSeguro(request));
                    request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
                }
                response.sendRedirect("UsuariosServlet");
                return;
            }

            // ==== ADMIN: CREAR / EDITAR ====
            String nombreUsuario = request.getParameter("nombre");
            String apellidoUsuario = request.getParameter("apellido");
            String claveUsuario = request.getParameter("clave");
            String mailUsuario = request.getParameter("mail");
            String rolUsuario = request.getParameter("rol");
            String usuarioUsuario = request.getParameter("usuario");
            String s = request.getParameter("supervisor");
            Integer supervisor = (s != null && !s.isEmpty()) ? Integer.parseInt(s) : null;

            if (id != 0) {
                Usuario existente = userDAO.getOne(id);
                // si no se cambia clave, conservar la anterior
                if (claveUsuario == null || claveUsuario.isEmpty()) {
                    claveUsuario = existente.getClave();
                }
            }

            Usuario user = new Usuario(id, nombreUsuario, apellidoUsuario, mailUsuario,
                    claveUsuario, usuarioUsuario, rolUsuario, supervisor);

            if (id == 0) {
                userDAO.add(user); // genera nuevo salt
            } else {
                userDAO.update(user); // genera nuevo salt solo si cambia clave
            }

            response.sendRedirect("UsuariosServlet");

        } catch (DAOException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("usuarios", cargarUsuariosSeguro(request));
            request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error al procesar datos numéricos: " + e.getMessage());
            request.setAttribute("usuarios", cargarUsuariosSeguro(request));
            request.getRequestDispatcher("usuarios/listado.jsp").forward(request, response);
        }
    }
}
