"use client"

import Link from "next/link"

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col">
      {/* Hero Section - Simple and action-focused */}
      <section className="flex flex-1 flex-col items-center justify-center px-6 py-16 text-center">
        <div className="mx-auto max-w-5xl space-y-8">
          {/* Main Heading */}
          <h1 className="text-5xl font-medium leading-[1.08] tracking-tight sm:text-6xl lg:text-7xl">
            Build Anything.
          </h1>

          {/* Subtitle */}
          <p className="mx-auto max-w-2xl text-lg leading-relaxed text-muted-foreground">
            Describe your idea and watch it come to life. No code needed.
          </p>

          {/* Simple instruction */}
          <div className="mx-auto max-w-2xl space-y-4 rounded-2xl border border-border bg-muted/20 p-8">
            <div className="space-y-3">
              <p className="text-base font-medium">To get started:</p>
              <ol className="space-y-3 text-left text-sm text-muted-foreground">
                <li className="flex items-start gap-3">
                  <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full border border-border bg-background text-sm font-medium">
                    1
                  </span>
                  <span>
                    Type{" "}
                    <span className="font-mono text-sm bg-background px-2 py-1 rounded border border-border">
                      /brainstorm
                    </span>{" "}
                    in the chat
                  </span>
                </li>
                <li className="flex items-start gap-3">
                  <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full border border-border bg-background text-sm font-medium">
                    2
                  </span>
                  <span>Describe your idea in plain English</span>
                </li>
                <li className="flex items-start gap-3">
                  <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full border border-border bg-background text-sm font-medium">
                    3
                  </span>
                  <span>The AI will help you refine it and build it</span>
                </li>
              </ol>
            </div>
          </div>

          {/* Quick examples */}
          <div className="space-y-3">
            <p className="text-sm font-medium text-muted-foreground">
              Example ideas:
            </p>
            <div className="flex flex-wrap justify-center gap-2">
              {[
                "A recipe sharing app",
                "Personal blog",
                "Task manager",
                "Photo gallery",
                "Online store",
                "Booking system",
              ].map((example) => (
                <div
                  key={example}
                  className="rounded-full border border-border bg-background px-3 py-1.5 text-xs text-muted-foreground"
                >
                  {example}
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-border py-12 px-6 text-center">
        <div className="container mx-auto space-y-4">
          <div className="flex items-center justify-center gap-6 text-sm text-muted-foreground">
            <Link
              href="/about"
              className="hover:text-foreground transition-colors"
            >
              About
            </Link>
            <Link
              href="/dashboard"
              className="hover:text-foreground transition-colors"
            >
              Dashboard
            </Link>
            <Link
              href="/login"
              className="hover:text-foreground transition-colors"
            >
              Sign In
            </Link>
          </div>
          <p className="text-sm text-muted-foreground">
            Built with Dream App •{" "}
            <Link
              href="https://getdreamapp.com"
              className="font-medium underline underline-offset-4 hover:text-foreground"
            >
              getdreamapp.com
            </Link>
          </p>
        </div>
      </footer>
    </div>
  )
}
