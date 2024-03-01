import React from 'react'
import Image from 'next/image'
import Link from 'next/link'
// IMPORT ICONS
import { MdNotifications, MdOutlineSearch } from "react-icons/md";
import { CgMenuLeft, CgMenuRight } from 'react-icons/cg';
// INTERNAL IMPORTS
import { Discover, HelpCenter, Notification, Profile, Sidebar } from './index'
import { Button } from '../index'

const Navbar = () => {
  return (
    <div className='w-full bg-black-100 p-4 shadow-md mb-4 sticky top-0 z-50'>
      <div className='flex justify-between items-center'>
        <div className='flex items-center'>
          <Link href='/'>
            <Image src='/vercel.svg' alt='logo' width={100} height={50} />
          </Link>
          <div className='ml-4 hidden md:flex'>
            <Discover />
            <HelpCenter />
          </div>
        </div>
        <div className='flex items-center'>
          <div className='hidden md:flex'>
            <Notification />
            <Profile />
          </div>
          <Button
              icon={<MdOutlineSearch />}
              className='mr-2'
            />
            <Button
              icon={<MdNotifications />}
              className='mr-2'
            />
          <div className='md:hidden'>
            
            <Sidebar
              left={<CgMenuLeft />}
              right={<CgMenuRight />}
            />
          </div>
        </div>
      </div>
    </div>
  )
}

export default Navbar