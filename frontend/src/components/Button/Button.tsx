import React from 'react'

interface ButtonProps {
  icon?: any
  left?: any
  right?: any
  text?: string
  className?: string
  children?: any
}

export const Button = (props: ButtonProps) => {
  return (
    <button className={`btn ${props.className}`}>
      {props.icon && <span className="btn-icon">{props.icon}</span>}
      {props.left && <span className="btn-left">{props.left}</span>}
      {props.children}
      {props.right && <span className="btn-right">{props.right}</span>}
      {props.text && <span className="btn-text">{props.text}</span>}
    </button>
  )
}
