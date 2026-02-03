import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

Deno.serve(async (req) => {
  try {
    // 1. Initialize Supabase Client
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 2. Fetch from NewsData.io
    // Replace 'YOUR_API_KEY' with your actual key from newsdata.io
    const API_KEY = 'pub_c8121a77a29d4343aa0ecc905c922886'
    const response = await fetch(`https://newsdata.io/api/1/news?apikey=${API_KEY}&language=en&category=technology`)
    
    if (!response.ok) throw new Error('Failed to fetch news')
    const data = await response.json()

    // 3. Map API results to your NewsCardDB table columns
    const newsItems = data.results.map((item: any) => {
      // Handle tags/categories properly - ensure it's always an array
      let tags: string[] = []
      if (Array.isArray(item.category)) {
        tags = item.category
      } else if (typeof item.category === 'string') {
        tags = [item.category]
      } else if (item.keywords && Array.isArray(item.keywords)) {
        tags = item.keywords
      }
      
      // Add default tech tag if no categories exist
      if (tags.length === 0) {
        tags = ['technology']
      }
      
      return {
        title: item.title,
        description: item.description || "No description available",
        image_url: item.image_url,
        article_url: item.link,
        source: item.source_id || "Unknown",
        user_name: "Insider AI",
        profile_color: "#6366F1", // Indigo hex
        tags: tags, // Now properly formatted as array
        // Formats the date for Supabase
        published_date: item.pubDate ? new Date(item.pubDate).toISOString() : new Date().toISOString()
      }
    })

    // 4. Save to Database
    // 'onConflict' uses article_url to skip articles you've already saved
    const { error } = await supabase
      .from('news_cards')
      .upsert(newsItems, { onConflict: 'article_url' })

    if (error) throw error

    return new Response(JSON.stringify({ message: "Success", count: newsItems.length }), {
      headers: { "Content-Type": "application/json" }
    })

  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" }
    })
  }
})
