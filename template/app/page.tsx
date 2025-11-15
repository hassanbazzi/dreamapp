"use client"

import Link from "next/link"

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center p-8">
      <div className="max-w-2xl text-center space-y-8">
        <h1 className="text-4xl font-bold tracking-tight sm:text-6xl">
          Welcome to{" "}
          <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Dream App
          </span>
        </h1>
        <p className="text-xl text-muted-foreground">
          Your app is ready to build. Start customizing by asking your AI
          assistant what you want to create.
        </p>
        <div className="flex gap-4 justify-center">
          <Link
            href="/login"
            className="rounded-lg bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground shadow-sm hover:bg-primary/90 transition-colors"
          >
            Get Started
          </Link>
          <Link
            href="/about"
            className="rounded-lg border border-border px-6 py-3 text-sm font-semibold hover:bg-accent transition-colors"
          >
            Learn More
          </Link>
        </div>
      </div>
    </div>
  )
}

