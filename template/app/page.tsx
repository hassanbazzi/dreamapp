"use client"

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center p-8 bg-gradient-to-b from-background to-muted/20">
      <div className="max-w-3xl w-full space-y-12">
        <div className="text-center space-y-4">
          <h1 className="text-5xl font-bold tracking-tight sm:text-6xl">
            ✨ Welcome to{" "}
            <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              Dream App
            </span>
            !
          </h1>
          <p className="text-xl text-muted-foreground">
            You're all set up! Your app is ready to build.
          </p>
        </div>

        <div className="space-y-8 bg-card border rounded-lg p-8 shadow-sm">
          <div>
            <h2 className="text-2xl font-semibold mb-4">
              Get Started (Two Quick Steps!)
            </h2>

            <div className="space-y-6">
              <div className="space-y-2">
                <h3 className="text-lg font-semibold flex items-center gap-2">
                  <span className="flex items-center justify-center w-6 h-6 rounded-full bg-primary text-primary-foreground text-sm">
                    1
                  </span>
                  Press{" "}
                  <code className="px-2 py-1 bg-muted rounded text-sm">
                    Cmd + L
                  </code>
                </h3>
                <p className="text-muted-foreground ml-8">
                  (or{" "}
                  <code className="px-2 py-1 bg-muted rounded text-sm">
                    Ctrl + L
                  </code>{" "}
                  on Windows)
                </p>
                <p className="text-muted-foreground ml-8">
                  This opens your AI assistant.
                </p>
              </div>

              <div className="space-y-2">
                <h3 className="text-lg font-semibold flex items-center gap-2">
                  <span className="flex items-center justify-center w-6 h-6 rounded-full bg-primary text-primary-foreground text-sm">
                    2
                  </span>
                  Say this:
                </h3>
                <div className="ml-8 space-y-2">
                  <div className="bg-muted p-3 rounded-md font-mono text-sm">
                    Let's get started!
                  </div>
                  <p className="text-muted-foreground text-center">or</p>
                  <div className="bg-muted p-3 rounded-md font-mono text-sm">
                    I want to build [describe your idea]
                  </div>
                </div>
              </div>
            </div>

            <div className="mt-6 p-4 bg-blue-50 dark:bg-blue-950/20 border border-blue-200 dark:border-blue-900 rounded-lg">
              <p className="text-sm">
                <strong>That's it!</strong> Your assistant can see your app in
                the browser and will help you build whatever you want.
              </p>
              <p className="text-sm text-muted-foreground mt-2">
                💡 <strong>Pro tip:</strong> Your dev server is already running
                and visible in the browser tab! Look at the bottom panel to see
                the server logs.
              </p>
            </div>
          </div>

          <hr className="border-border" />

          <div>
            <h2 className="text-2xl font-semibold mb-4">What You Can Build</h2>
            <p className="text-muted-foreground mb-4">
              Just describe what you want in plain English:
            </p>
            <div className="space-y-2">
              <div className="p-3 bg-muted rounded-md text-sm">
                "Add a page where users can create notes"
              </div>
              <div className="p-3 bg-muted rounded-md text-sm">
                "Make the homepage more colorful"
              </div>
              <div className="p-3 bg-muted rounded-md text-sm">
                "Add a profile page with user settings"
              </div>
              <div className="p-3 bg-muted rounded-md text-sm">
                "Create a todo list"
              </div>
              <div className="p-3 bg-muted rounded-md text-sm">
                "Add dark mode"
              </div>
            </div>
            <p className="text-sm text-muted-foreground mt-4">
              Your assistant will build it, test it, and show you it working.
            </p>
          </div>

          <hr className="border-border" />

          <div>
            <h2 className="text-2xl font-semibold mb-4">Need Help?</h2>
            <p className="text-muted-foreground mb-4">
              Just ask your assistant:
            </p>
            <ul className="space-y-2 text-sm">
              <li className="flex items-start gap-2">
                <span className="text-primary">•</span>
                <span>"What can I build?"</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-primary">•</span>
                <span>"Show me some examples"</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-primary">•</span>
                <span>"I have an idea but not sure how to describe it"</span>
              </li>
            </ul>
          </div>
        </div>

        <div className="text-center space-y-4">
          <p className="text-2xl font-semibold">
            Ready? Press{" "}
            <code className="px-2 py-1 bg-muted rounded text-sm">Cmd + L</code>{" "}
            and say "Get started" 🚀
          </p>
          <p className="text-sm text-muted-foreground">
            From{" "}
            <a
              href="https://getdreamapp.com"
              className="text-primary hover:underline"
              target="_blank"
              rel="noopener noreferrer"
            >
              getdreamapp.com
            </a>{" "}
            with ❤️
          </p>
        </div>
      </div>
    </div>
  )
}
