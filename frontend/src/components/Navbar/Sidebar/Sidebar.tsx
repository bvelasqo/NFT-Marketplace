import React from 'react'

interface SidebarProps {
  left?: any
  right?: any
  children?: React.ReactNode
}

export const Sidebar = (props: SidebarProps) => {
  return (
    <div className="sidebar">
      {props.left && <div className="sidebar-left">{props.left}</div>}
      {props.children}
      {props.right && <div className="sidebar-right">{props.right}</div>}
    </div>
  )
}
