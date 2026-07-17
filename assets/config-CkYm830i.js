var e={accentColor:`#4fc3f7`,baseUrl:`https://cattery.nixcafe.org`,basePath:`/`,cacheDir:`/home/runner/work/nixcafe-docs/nixcafe-docs/apps/cattery-modules/node_modules/.cache/vocs`,checkDeadlinks:`warn`,codeHighlight:{langAlias:{sol:`solidity`,js:`javascript`,cjs:`javascript`,mjs:`javascript`,md:`markdown`,jade:`pug`,ts:`typescript`,cts:`typescript`,mts:`typescript`,coffeescript:`coffee`,regex:`regexp`,"c++":`cpp`,gql:`graphql`,yml:`yaml`,hbs:`handlebars`,bash:`shellscript`,sh:`shellscript`,shell:`shellscript`,zsh:`shellscript`,py:`python`,jl:`julia`,styl:`stylus`,lit:`ts-tags`,dockerfile:`docker`,protobuf:`proto`,rs:`rust`},langs:[`ansi`,`bash`,`html`,`js`,`json`,`jsx`,`markdown`,`md`,`mdx`,`plaintext`,`rust`,`sol`,`solidity`,`ts`,`tsx`,`zsh`,`nix`],themes:{light:`github-light`,dark:`github-dark-dimmed`}},colorScheme:`dark`,description:`cattery-modules — quick-start NixOS configurations with room-based module bundles`,editLink:{text:`Suggest changes to this page`,link:`https://github.com/nixcafe/nixcafe-docs/edit/main/apps/cattery-modules/src/pages/:path`},feedback:!1,head:`_vocs-fn_() => ({
		meta: {
			ogType: "website",
			ogSiteName: "nixcafe",
			twitterCard: "summary_large_image",
			robots: "index, follow",
			author: "nixcafe",
			themeColor: "#0d0d0d"
		},
		link: [{
			rel: "sitemap",
			type: "application/xml",
			href: "https://cattery.nixcafe.org/sitemap.xml"
		}],
		script: [{
			type: "application/ld+json",
			textContent: {
				"@context": "https://schema.org",
				"@graph": [{
					"@type": "SoftwareSourceCode",
					name: "cattery-modules",
					description: "Quick-start NixOS configurations — choose a room, get a complete system",
					url: "https://cattery.nixcafe.org",
					codeRepository: "https://github.com/nixcafe/cattery-modules",
					programmingLanguage: "Nix",
					applicationCategory: "DeveloperApplication",
					license: "CC0-1.0"
				}, {
					"@type": "WebSite",
					name: "cattery-modules",
					url: "https://cattery.nixcafe.org",
					description: "cattery-modules — NixOS quick-start module documentation"
				}]
			}
		}]
	})`,iconUrl:{light:`/logo.svg`,dark:`/logo-dark.svg`},logoUrl:{light:`/logo.svg`,dark:`/logo-dark.svg`},outDir:`dist`,pagesDir:`pages`,renderStrategy:`full-static`,rootDir:`/home/runner/work/nixcafe-docs/nixcafe-docs/apps/cattery-modules`,search:{query:{boostDocument:`_vocs-fn_(_id, _term, storedFields) => {
                    const priority = storedFields?.['searchPriority'] ?? 1;
                    const href = storedFields?.['href'];
                    const isDocsPath = href?.startsWith('/docs/');
                    // Treat /docs/ as root for depth calculation (subtract 1)
                    const segments = href ? href.split('/').filter(Boolean).length : 1;
                    const depth = isDocsPath ? Math.max(segments - 1, 1) : segments;
                    const depthBoost = 1 / Math.max(depth, 1);
                    const docsBoost = isDocsPath ? 1.5 : 1;
                    return priority * depthBoost * docsBoost;
                }`,combineWith:`AND`,fuzzy:.2,prefix:!0,boost:{title:4,subtitle:3,text:2,category:1,titles:1}},boostDocument:`_vocs-fn_(_id, _term, storedFields) => {
                    const priority = storedFields?.['searchPriority'] ?? 1;
                    const href = storedFields?.['href'];
                    const isDocsPath = href?.startsWith('/docs/');
                    // Treat /docs/ as root for depth calculation (subtract 1)
                    const segments = href ? href.split('/').filter(Boolean).length : 1;
                    const depth = isDocsPath ? Math.max(segments - 1, 1) : segments;
                    const depthBoost = 1 / Math.max(depth, 1);
                    const docsBoost = isDocsPath ? 1.5 : 1;
                    return priority * depthBoost * docsBoost;
                }`,combineWith:`AND`,fuzzy:.2,prefix:!0,boost:{title:4,subtitle:3,text:2,category:1,titles:1}},sidebar:[{text:`Introduction`,link:`/`},{text:`Guide`,collapsed:!1,items:[{text:`Quick Start`,link:`/quick-start`},{text:`Rooms`,link:`/rooms`},{text:`Modules`,link:`/modules`}]}],socials:[{icon:`github`,link:`https://github.com/nixcafe`}],srcDir:`src`,title:`cattery-modules`,titleTemplate:`%s – cattery-modules`,trailingSlashRedirect:!0};export{e as t};