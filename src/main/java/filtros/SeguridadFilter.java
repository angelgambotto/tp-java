package filtros;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import usuarios.Usuario;

@WebFilter("/")
public class SeguridadFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        // Recursos públicos
        if (path.contains("login") || path.contains("css") || path.contains("js") || path.contains("images")) {
            chain.doFilter(request, response);
            return;
        }

        // Sesión obligatoria
        if (usuario == null) {
            res.sendRedirect(req.getContextPath() + "/LoginServlet");
            return;
        }

        String rol = usuario.getRol().toUpperCase();

        // Reglas de acceso
        if (path.contains("/UsuariosServlet") && !rol.equals("ADMINISTRADOR")) {
            res.sendRedirect(req.getContextPath() + "/sinPermiso.jsp");
            return;
        }

        if (path.contains("/ProyectoServlet") &&
                !(rol.equals("ADMINISTRADOR") || rol.equals("SUPERVISOR"))) {
            res.sendRedirect(req.getContextPath() + "/sinPermiso.jsp");
            return;
        }

        if (path.contains("/ClienteServlet") &&
                !(rol.equals("ADMINISTRADOR") || rol.equals("SUPERVISOR"))) {
            res.sendRedirect(req.getContextPath() + "/sinPermiso.jsp");
            return;
        }

        if (path.contains("/CategoriaTareaServlet") &&
                !(rol.equals("ADMINISTRADOR") || rol.equals("SUPERVISOR"))) {
            res.sendRedirect(req.getContextPath() + "/sinPermiso.jsp");
            return;
        }

        // (opcional) proteger ABMC Tareas / Etapas
        if (path.contains("/TareaServlet") &&
                !(rol.equals("ADMINISTRADOR") || rol.equals("SUPERVISOR") || rol.equals("EMPLEADO") || rol.equals("USUARIO"))) {
            res.sendRedirect(req.getContextPath() + "/sinPermiso.jsp");
            return;
        }

        // Si todo OK → continuar
        chain.doFilter(request, response);
    }
}
