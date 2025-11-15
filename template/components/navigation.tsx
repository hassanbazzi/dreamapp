"use client"

import Link from "next/link"
import { useState } from "react"
import { Menu, X } from "lucide-react"

export function Navigation() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

  return (
    <header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <nav className="container mx-auto flex h-16 items-center justify-between px-6">
        <Link href="/" className="flex items-center">
          <span className="text-xl font-semibold">Dream App</span>
        </Link>

        {/* Desktop Navigation */}
        <div className="hidden md:flex md:items-center md:space-x-8">
          <Link
            href="/about"
            className="text-[15px] font-medium text-foreground/80 transition-colors hover:text-foreground"
          >
            About
          </Link>
          <Link
            href="/dashboard"
            className="text-[15px] font-medium text-foreground/80 transition-colors hover:text-foreground"
          >
            Dashboard
          </Link>
          <Link
            href="/login"
            className="text-[15px] font-medium text-foreground/80 transition-colors hover:text-foreground"
          >
            Sign In
          </Link>
          <Link
            href="/signup"
            className="inline-flex h-10 items-center justify-center rounded-full bg-foreground px-6 text-[15px] font-medium text-background transition-all hover:bg-foreground/90"
          >
            Get Started
          </Link>
        </div>

        {/* Mobile Menu Button */}
        <button
          className="md:hidden rounded-md p-2 hover:bg-accent"
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          aria-label="Toggle menu"
        >
          {mobileMenuOpen ? (
            <X className="h-5 w-5" />
          ) : (
            <Menu className="h-5 w-5" />
          )}
        </button>
      </nav>

      {/* Mobile Navigation */}
      {mobileMenuOpen && (
        <div className="md:hidden border-t border-border/40 bg-background">
          <div className="container mx-auto space-y-1 px-6 py-4">
            <Link
              href="/about"
              className="block rounded-lg px-3 py-2.5 text-[15px] font-medium text-foreground/80 hover:bg-muted hover:text-foreground"
              onClick={() => setMobileMenuOpen(false)}
            >
              About
            </Link>
            <Link
              href="/dashboard"
              className="block rounded-lg px-3 py-2.5 text-[15px] font-medium text-foreground/80 hover:bg-muted hover:text-foreground"
              onClick={() => setMobileMenuOpen(false)}
            >
              Dashboard
            </Link>
            <Link
              href="/login"
              className="block rounded-lg px-3 py-2.5 text-[15px] font-medium text-foreground/80 hover:bg-muted hover:text-foreground"
              onClick={() => setMobileMenuOpen(false)}
            >
              Sign In
            </Link>
            <Link
              href="/signup"
              className="mt-2 flex h-10 items-center justify-center rounded-full bg-foreground text-[15px] font-medium text-background"
              onClick={() => setMobileMenuOpen(false)}
            >
              Get Started
            </Link>
          </div>
        </div>
      )}
    </header>
  )
}

