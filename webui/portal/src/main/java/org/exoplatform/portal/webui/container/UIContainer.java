/**
 * Copyright (C) 2009 eXo Platform SAS.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

package org.exoplatform.portal.webui.container;

import org.exoplatform.container.ExoContainer;
import org.exoplatform.container.ExoContainerContext;
import org.exoplatform.portal.config.UserACL;
import org.exoplatform.portal.webui.portal.UIPortalComponent;
import org.exoplatform.portal.webui.portal.UIPortalComponentActionListener.DeleteComponentActionListener;
import org.exoplatform.webui.config.annotation.ComponentConfig;
import org.exoplatform.webui.config.annotation.EventConfig;

/**
 * May 19, 2006
 */
@ComponentConfig(events = { @EventConfig(listeners = UIContainerActionListener.EditContainerActionListener.class),
        @EventConfig(listeners = DeleteComponentActionListener.class, confirm = "UIContainer.deleteContainer") })
public class UIContainer extends UIPortalComponent {
    public static final String TABLE_COLUMN_CONTAINER = "TableColumnContainer";

    /** Storage id. */
    private String storageId;

    protected String icon;

    protected String description;

    protected String[] moveContainersPermissions;

    protected String[] moveAppsPermissions;

    public UIContainer() {
    }

    public String getStorageId() {
        return storageId;
    }

    public void setStorageId(String storageId) {
        this.storageId = storageId;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String s) {
        icon = s;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String desc) {
        this.description = desc;
    }


    public String[] getMoveContainersPermissions() {
        return moveContainersPermissions;
    }

    public void setMoveContainersPermissions(String[] moveContainersPermissions) {
        this.moveContainersPermissions = moveContainersPermissions;
    }

    public boolean hasMoveContainersPermission() {
        ExoContainer exoContainer = ExoContainerContext.getCurrentContainer();
        UserACL acl = (UserACL) exoContainer.getComponentInstanceOfType(UserACL.class);
        return acl.hasPermission(moveContainersPermissions);
    }

    public String[] getMoveAppsPermissions() {
        return moveAppsPermissions;
    }

    public void setMoveAppsPermissions(String[] moveAppsPermissions) {
        this.moveAppsPermissions = moveAppsPermissions;
    }

    public boolean hasMoveAppsPermission() {
        ExoContainer exoContainer = ExoContainerContext.getCurrentContainer();
        UserACL acl = (UserACL) exoContainer.getComponentInstanceOfType(UserACL.class);
        return acl.hasPermission(moveAppsPermissions);
    }

    public String getPermissionClasses() {
        StringBuilder permissionClasses = new StringBuilder();
        if (!hasAccessPermission()) {
            permissionClasses.append(" ProtectedContainer");
        }
        if (!hasMoveAppsPermission()) {
            permissionClasses.append(" CannotMoveApps");
        }
        if (!hasMoveContainersPermission()) {
            permissionClasses.append(" CannotMoveContainers");
        }
        return permissionClasses.toString();
    }

}
