import { NextRequest, NextResponse } from "next/server"
import { db } from "@/lib/db"
import { notes } from "@/db/schema"
import { eq } from "drizzle-orm"

// GET /api/notes - List all notes for user
export async function GET(request: NextRequest) {
  try {
    // TODO: Get user ID from session/auth
    // For now, this is a placeholder
    const userId = "placeholder-user-id"

    const userNotes = await db
      .select()
      .from(notes)
      .where(eq(notes.userId, userId))

    return NextResponse.json(userNotes)
  } catch (error) {
    console.error("Error fetching notes:", error)
    return NextResponse.json(
      { error: "Failed to fetch notes" },
      { status: 500 }
    )
  }
}

// POST /api/notes - Create a new note
export async function POST(request: NextRequest) {
  try {
    // TODO: Get user ID from session/auth
    const userId = "placeholder-user-id"

    const body = await request.json()
    const { title, body: noteBody } = body

    if (!title) {
      return NextResponse.json({ error: "Title is required" }, { status: 400 })
    }

    const [note] = await db
      .insert(notes)
      .values({
        userId,
        title,
        body: noteBody,
      })
      .returning()

    return NextResponse.json(note, { status: 201 })
  } catch (error) {
    console.error("Error creating note:", error)
    return NextResponse.json(
      { error: "Failed to create note" },
      { status: 500 }
    )
  }
}

