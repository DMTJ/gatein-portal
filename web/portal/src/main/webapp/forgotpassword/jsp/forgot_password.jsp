<%--

    Copyright (C) 2009 eXo Platform SAS.
    
    This is free software; you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License as
    published by the Free Software Foundation; either version 2.1 of
    the License, or (at your option) any later version.
    
    This software is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    Lesser General Public License for more details.
    
    You should have received a copy of the GNU Lesser General Public
    License along with this software; if not, write to the Free
    Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
    02110-1301 USA, or see the FSF site: http://www.fsf.org.

--%>

<%@ page import="org.exoplatform.container.PortalContainer"%>
<%@ page import="org.exoplatform.services.resources.ResourceBundleService"%>
<%@ page import="org.exoplatform.portal.resource.SkinService"%>
<%@ page import="java.util.ResourceBundle"%>
<%@ page import="org.exoplatform.web.controller.QualifiedName" %>
<%@ page import="org.exoplatform.web.login.recovery.PasswordRecoveryService" %>
<%@ page import="org.exoplatform.portal.resource.SkinConfig" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.exoplatform.commons.utils.I18N" %>
<%@ page language="java" %>
<%
    PortalContainer portalContainer = PortalContainer.getCurrentInstance(session.getServletContext());
    ResourceBundleService service = portalContainer.getComponentInstanceOfType(ResourceBundleService.class);
    Locale locale = (Locale)request.getAttribute("request_locale");
    if (locale == null) {
        locale = request.getLocale();
    }
    ResourceBundle res = service.getResourceBundle(service.getSharedResourceBundleNames(), locale);
    String contextPath = portalContainer.getPortalContext().getContextPath();

    SkinService skinService = PortalContainer.getCurrentInstance(session.getServletContext())
            .getComponentInstanceOfType(SkinService.class);

    Collection<SkinConfig> skins = skinService.getPortalSkins("Default");
    String loginCssPath = skinService.getSkin("portal/login", "Default").getCSSPath();

    String username = (String)request.getAttribute("username");
    String error = (String)request.getAttribute("error");
    String success = (String)request.getAttribute("success");

    PasswordRecoveryService passRecoveryServ = portalContainer.getComponentInstanceOfType(PasswordRecoveryService.class);
    String forgotPasswordPath = passRecoveryServ.getPasswordRecoverURL(null, I18N.toTagIdentifier(locale));


    String initURL = (String)request.getAttribute("initURL");
    if (initURL == null) {
        initURL = contextPath + "/login";
    }

    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=res.getString("gatein.forgotPassword.title")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="shortcut icon" type="image/x-icon"  href="<%=contextPath%>/favicon.ico" />
    <% for (SkinConfig skin : skins) {
        if ("CoreSkin".equals(skin.getModule()) || "CoreSkin1".equals(skin.getModule())) {%>
    <link href="<%=skin.getCSSPath()%>" rel="stylesheet" type="text/css" test="<%=skin.getModule()%>"/>
    <%}%>
    <%}%>
    <link href="<%=loginCssPath%>" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="/eXoResources/javascript/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="/eXoResources/javascript/eXo/webui/FormValidation.js"></script>
</head>
<body class="modal-open">
<div class="uiPopupWrapper">
    <div class="UIPopupWindow uiPopup uiForgotPassword UIDragObject NormalStyle">
        <div class="popupHeader ClearFix">
            <span class="popupTitle center"><%=res.getString("gatein.forgotPassword.title")%></span>
        </div>
        <div class="popupContent">
            <% if (success != null) { %>
            <div class="alertForm">
                <div class="alert alert-success">
                    <i class="uiIconSuccess"></i><%=success%>
                </div>
            </div>
            <%}%>
            <form name="registerForm" action="<%= contextPath + forgotPasswordPath %>" method="post" style="margin: 0px;" autocomplete="off">
                <div class="">
                    <div class="text">
                        <h5><%=res.getString("gatein.forgotPassword.message.heading")%></h5>
                        <%=res.getString("gatein.forgotPassword.message.msg1")%>
                        <br/>
                        <%=res.getString("gatein.forgotPassword.message.msg2")%>
                    </div>
                    <div>
                        
                            <input style="width: 100%;" data-validation="require" class="username" name="username" type="text" value="<%=(username != null ? username : "")%>" placeholder="<%=res.getString("gatein.forgotPassword.usernameOrEmail")%>"/>
                            <% if (error != null) { %>
                                <br/>
                                <span class="mgT5" style="display: inline-block;color: #333;"><i class="uiIconColorError"></i> <%=error%></span>
                            <%}%>
                        
                    </div>
                    <input type="hidden" name="action" value="send"/>
                    <input type="hidden" name="initURL" value="<%=initURL%>"/>
                </div>
                <div id="UIPortalLoginFormAction" class="uiAction">
                    <button type="submit" class="btn btn-primary disabled" disabled="disabled"><%=res.getString("gatein.forgotPassword.send")%></button>
                    <a href="<%=initURL%>" class="btn ActionButton LightBlueStyle"><%=res.getString("gatein.forgotPassword.back")%></a>
                </div>
            </form>
        </div>
    </div>
</div>
<script type="text/javascript">
  var $form = $('form[name="registerForm"]');
  $form.on('formValidate', function(e, valid) {
    var $btnSubmit = $form.find('.btn[type="submit"]');
    if (valid) {      
      $btnSubmit.attr('disabled', false).removeClass('disabled');
    } else {
      $btnSubmit.attr('disabled', true).addClass('disabled');
    }
  });
  $form.find('input[type="text"]').on('keyup', function() {
    $form.validate();
  });
</script>
</body>
</html>